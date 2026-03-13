<#

.SYNOPSIS

    Azure Cloud Sizing Script v2.1 - Parallel ARG + Monitor Hybrid Architecture

.DESCRIPTION

    Inventories Azure Virtual Machines, Storage Accounts, File Shares, NetApp File Volumes,

    SQL Databases/Managed Instances, MySQL Servers, PostgreSQL Servers, CosmosDB Accounts,

    and Azure Kubernetes Service (AKS) clusters across all or specified subscriptions.

    Calculates disk sizes for VMs, storage capacity utilization for Storage Accounts,

    capacity metrics for File Shares, usage metrics for NetApp File Volumes, database

    storage metrics for SQL, MySQL, PostgreSQL, and CosmosDB resources, and persistent

    volume information for AKS clusters.

    Generates detailed CSV reports with comprehensive sizing information in multiple

    units (GB, TB, TiB), plus an executive Excel report with pivot tables and charts.

    Includes comprehensive logging and creates a ZIP archive of all results.

    ARCHITECTURE (v2.1 improvements over v2.0):

      - All 17 identified gaps addressed (see CHANGELOG below)

      - Per-item backup storage size via REST extendedInfo expansion
      - Recovery point inventory per protected item
      - Backup Vault policy capture (rule-based schema)
      - SQL automated backup storage metrics (backup_storage_used)
      - MySQL/PostgreSQL backup storage metrics
      - VM restore point collections (enhanced backup policy)
      - ASR replica disk size extraction from providerSpecificDetails
      - File Share snapshot enumeration via REST
      - Full storage service breakdown (File/Table/Queue capacity)
      - VM power state from ARG instanceView
      - Orphaned disk detection and reporting
      - Standardized batch metrics fallback pattern
      - Dual grand totals (Provisioned/MaxSize AND Utilized/Actual)
      - Renamed -Confirm to -Interactive to avoid ShouldProcess conflict

    ARCHITECTURE (v2.0 base):

      - Azure Resource Graph (ARG) replaces sequential Get-Az* loops (10-50x faster discovery)

      - PowerShell 7 ForEach-Object -Parallel for concurrent subscription processing

      - Exponential backoff with jitter for 429 throttling resilience

      - Pre-flight RBAC access validation per subscription (skips gracefully on access denied)

      - Process-scoped Az context isolation prevents credential bleed across threads

      - ImportExcel executive report with pivot table and bar chart

      - Maintains full CSV compatibility with original Commvault vendor export format

.PARAMETER Types

    Optional. Restrict inventory to specific resource types.

    Valid values: VM, Storage, FileShare, NetApp, SQL, Cosmos, AKS, RSV, Backup, Snapshot, ASR

    If not specified, all supported resource types will be inventoried.

    Note: MySQL and PostgreSQL servers are included as part of SQL inventory.

.PARAMETER Subscriptions

    Optional. Target specific subscriptions by name or ID.

    If not specified, all accessible subscriptions will be processed.

.PARAMETER ThreadCount

    Number of parallel subscription threads. Default: 5.

    Tune based on your environment; higher values increase speed but also API pressure.

    Maximum: 20.

.PARAMETER MaxRetries

    Maximum retry attempts for Azure API calls that return 429/5xx. Default: 3.

    Uses exponential backoff with jitter between retries. Maximum: 10.

.PARAMETER OutputPath

    Output directory for results. Default: C:\temp

    Directory will be created if it does not exist.

.PARAMETER ExcludeSubscriptions

    Optional. Subscription names or IDs to exclude from processing.

    Applied after -Subscriptions filter (if any). Useful for permanently

    skipping subscriptions with known access restrictions.

.PARAMETER Interactive

    When specified, displays a numbered list of discovered subscriptions

    and prompts you to exclude any by number before processing begins.

    Example: entering "3,7,15" excludes subscriptions at positions 3, 7, and 15.

    NOTE: This parameter was renamed from -Confirm in v2.0 to avoid conflict

    with PowerShell's built-in -Confirm ShouldProcess preference variable.

.PARAMETER SkipMetrics

    When specified, skips all Azure Monitor metric collection.

    Only ARG inventory data will be collected (much faster, no capacity data).

.EXAMPLE

    .\CVAzureCloudSizingScript.ps1

    # Inventories all resources in all accessible subscriptions (5 threads)

.EXAMPLE

    .\CVAzureCloudSizingScript.ps1 -Types VM,Storage,AKS

    # Inventories VMs, Storage Accounts, and AKS clusters in all subscriptions

.EXAMPLE

    .\CVAzureCloudSizingScript.ps1 -Types AKS

    # Only inventories Azure Kubernetes Service clusters in all subscriptions

.EXAMPLE

    .\CVAzureCloudSizingScript.ps1 -Subscriptions "Production","Development"

    # Inventories all resources in only the Production and Development subscriptions

.EXAMPLE

    .\CVAzureCloudSizingScript.ps1 -Subscriptions "Dev Test","Production Environment"

    # Inventories all resources in subscriptions with spaces in names (always use quotes for names with spaces)

    # IMPORTANT: If you pass a subscription name that contains spaces WITHOUT quotes, PowerShell will treat the words as separate arguments

    # and the script will not match the subscription. Example of the problem and fixes:

    #   WRONG (will fail / be parsed incorrectly):

    #     .\CVAzureCloudSizingScript.ps1 -Subscriptions Dev Test

    #   CORRECT (use double quotes):

    #     .\CVAzureCloudSizingScript.ps1 -Subscriptions "Dev Test"

    #   ALTERNATIVE (use single quotes):

    #     .\CVAzureCloudSizingScript.ps1 -Subscriptions 'Dev Test'

    # You can also pass multiple quoted names separated by commas:

    #     .\CVAzureCloudSizingScript.ps1 -Subscriptions "Dev Test","Production Environment"

.EXAMPLE

    .\CVAzureCloudSizingScript.ps1 -Subscriptions Production,Development

    # Inventories all resources in the subscriptions Production and Development (no spaces in names)

.EXAMPLE

    .\CVAzureCloudSizingScript.ps1 -Types NetApp

    # Only inventories NetApp File volumes in all subscriptions

.EXAMPLE

    .\CVAzureCloudSizingScript.ps1 -Types VM,Storage,NetApp -Subscriptions Production

    # Inventories VMs, Storage Accounts, and NetApp File Volumes in only the Production subscription

.EXAMPLE

    .\CVAzureCloudSizingScript.ps1 -Types Cosmos -Subscriptions "Development","Staging"

    # Only inventories CosmosDB accounts in the Development and Staging subscriptions

.EXAMPLE

    .\CVAzureCloudSizingScript.ps1 -Subscriptions xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx

    # Inventories all resources in the subscription with the specified Subscription ID

.EXAMPLE

    .\CVAzureCloudSizingScript.ps1 -Types VM,Storage -Subscriptions "Production","Development" -ThreadCount 8

    # VMs and Storage only, specific subscriptions, 8 parallel threads

.EXAMPLE

    .\CVAzureCloudSizingScript.ps1 -Types SQL,Cosmos -MaxRetries 5

    # SQL and Cosmos inventory with extra retry resilience

.EXAMPLE

    .\CVAzureCloudSizingScript.ps1 -OutputPath D:\Reports

    # All resources, custom output directory

.EXAMPLE

    .\CVAzureCloudSizingScript.ps1 -ExcludeSubscriptions "Sandbox","Lab-Internal"

    # All resources, all subscriptions except Sandbox and Lab-Internal

.EXAMPLE

    .\CVAzureCloudSizingScript.ps1 -Interactive

    # Discover all subscriptions, then interactively exclude by number before running

.EXAMPLE

    .\CVAzureCloudSizingScript.ps1 -Types VM,Storage -ExcludeSubscriptions "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" -Interactive

    # VM and Storage only, pre-exclude a subscription by ID, then review the rest interactively

.EXAMPLE

    .\CVAzureCloudSizingScript.ps1 -Types RSV,Backup,Snapshot,ASR

    # Only inventories backup and recovery related resources across all subscriptions

.EXAMPLE

    .\CVAzureCloudSizingScript.ps1 -SkipMetrics

    # Fast ARG-only inventory without Azure Monitor capacity metrics

.OUTPUTS

    Creates timestamped output directory with the following files:

    - azure_vm_info_YYYY-MM-DD_HHMMSS.csv                    VM inventory with disk sizing and power state
    - azure_orphaned_disks_YYYY-MM-DD_HHMMSS.csv              Unattached/orphaned managed disks
    - azure_storage_accounts_info_YYYY-MM-DD_HHMMSS.csv       Storage Account inventory with full service breakdown
    - azure_file_shares_info_YYYY-MM-DD_HHMMSS.csv            File Share inventory with capacity metrics and snapshot counts
    - azure_netapp_volumes_info_YYYY-MM-DD_HHMMSS.csv         NetApp Files volume inventory with capacity metrics
    - azure_sql_managed_instances_YYYY-MM-DD_HHMMSS.csv       SQL Managed Instances inventory
    - azure_sql_mi_databases_YYYY-MM-DD_HHMMSS.csv            SQL MI Database inventory with retention policies
    - azure_sql_databases_inventory_YYYY-MM-DD_HHMMSS.csv     SQL Databases inventory (includes elastic pool membership)
    - azure_sql_elastic_pools_YYYY-MM-DD_HHMMSS.csv           SQL Elastic Pools inventory with pool-level metrics
    - azure_sql_backup_storage_YYYY-MM-DD_HHMMSS.csv          SQL automated backup storage consumption per server
    - azure_mysql_servers_YYYY-MM-DD_HHMMSS.csv               MySQL Servers inventory (included with SQL inventory)
    - azure_postgresql_servers_YYYY-MM-DD_HHMMSS.csv          PostgreSQL Servers inventory (included with SQL inventory)
    - azure_cosmosdb_accounts_YYYY-MM-DD_HHMMSS.csv           CosmosDB Accounts inventory with storage metrics
    - azure_aks_clusters_YYYY-MM-DD_HHMMSS.csv                AKS Clusters inventory with node and storage information
    - azure_aks_persistent_volumes_YYYY-MM-DD_HHMMSS.csv      AKS Persistent Volumes inventory
    - azure_aks_persistent_volume_claims_YYYY-MM-DD_HHMMSS.csv AKS Persistent Volume Claims inventory
    - azure_rsv_vaults_YYYY-MM-DD_HHMMSS.csv                  Recovery Services Vaults with storage consumption
    - azure_rsv_protected_items_YYYY-MM-DD_HHMMSS.csv         RSV Protected Items with per-item backup size
    - azure_rsv_recovery_points_YYYY-MM-DD_HHMMSS.csv         RSV Recovery Points inventory (time, type, tier)
    - azure_rsv_backup_policies_YYYY-MM-DD_HHMMSS.csv         RSV Backup Policies with retention details
    - azure_backup_vaults_YYYY-MM-DD_HHMMSS.csv               Backup Vaults inventory with storage consumption
    - azure_backup_instances_YYYY-MM-DD_HHMMSS.csv            Backup Vault Instances inventory
    - azure_backup_vault_policies_YYYY-MM-DD_HHMMSS.csv       Backup Vault Policies (rule-based retention schema)
    - azure_disk_snapshots_YYYY-MM-DD_HHMMSS.csv              Disk Snapshots inventory
    - azure_vm_restore_points_YYYY-MM-DD_HHMMSS.csv           VM Restore Point Collections with disk sizes
    - azure_asr_replicated_items_YYYY-MM-DD_HHMMSS.csv        ASR Replicated Items with replica disk sizes
    - azure_inventory_summary_YYYY-MM-DD_HHMMSS.csv           Comprehensive summary with regional breakdowns
    - azure_sizing_executive_YYYY-MM-DD_HHMMSS.xlsx           Executive Excel report with pivot table and chart
    - azure_sizing_script_output_YYYY-MM-DD_HHMMSS.log        Complete execution log
    - azure_sizing_errors_YYYY-MM-DD_HHMMSS.csv               Access/error report (only if errors occurred)
    - azure_sizing_YYYY-MM-DD_HHMMSS.zip                      ZIP archive containing all output files

.NOTES

    REQUIREMENTS:

    - PowerShell 7+ (required for ForEach-Object -Parallel)

    - Az.Accounts (always required for authentication)

    - Az.ResourceGraph (required for ARG-based resource discovery)

    - Az.Monitor (for performance/capacity metrics)

    - Az.Resources (for resource group and subscription information)

    - Az.Compute (for VM sizing)

    - Az.Storage (for Storage Accounts and File Shares)

    - Az.NetAppFiles (for NetApp Volumes)

    - Az.CosmosDB (for CosmosDB accounts)

    - Az.Sql (for Azure SQL databases and servers)

    - Az.MySql (for MySQL servers)

    - Az.PostgreSql (for PostgreSQL servers)

    - Az.Aks (for AKS clusters)

    - Az.RecoveryServices (for Recovery Services Vaults and ASR)

    - ImportExcel (optional, auto-installed for executive .xlsx report)

    Script must be run by a user with appropriate Azure permissions to read VMs, Storage Accounts,

    File Shares, NetApp Volumes, SQL resources, CosmosDB accounts, MySQL servers, PostgreSQL servers,

    and AKS clusters across the targeted subscriptions.

    VM disk sizing includes both OS disks and data disks with error handling for inaccessible disks.

    Storage Account, File Share, NetApp Files, CosmosDB, MySQL, and PostgreSQL metrics are retrieved

    from Azure Monitor for the last 1 hour using Maximum aggregation.

    AKS (Azure Kubernetes Service) REQUIREMENTS:

    KUBECTL REQUIREMENT:

    - kubectl command-line tool is REQUIRED for AKS persistent volume analysis

    - If kubectl is not available, AKS functionality will be limited to basic cluster information only

    AZURE PERMISSIONS REQUIRED FOR AKS:

    - Azure RBAC should be enabled on target AKS clusters (recommended configuration)

    - Azure Kubernetes Service Cluster User role on target AKS clusters

    - Azure Kubernetes Service RBAC Reader role on target AKS clusters

    - Reader role on the subscription/resource group containing AKS clusters

    KUBERNETES RBAC REQUIREMENTS:

    - AKS clusters should have Azure RBAC integration enabled (recommended)

    - Required Kubernetes permissions: read access to persistentvolumes, persistentvolumeclaims, storageclasses, and nodes

    - Since the script uses Azure credentials, Azure RBAC roles determine access permissions

    NOTE: If insufficient permissions, kubectl commands will fail and AKS storage data collection will be incomplete.

    AKS CONNECTIVITY REQUIREMENTS:

    - Script must be able to connect to AKS cluster API servers

    - For private clusters, script must run from within the same virtual network or with proper connectivity

    - kubectl context will be automatically configured using Import-AzAksCredential for each cluster

    AKS DATA COLLECTED:

    - Basic cluster information (name, location, version, node pools)

    - Persistent Volume (PV) inventory with storage class, capacity, and status

    - Persistent Volume Claim (PVC) inventory with requested storage and binding status

    IMPORTANT: If Azure Monitor metrics are reported inaccurately or are not available for certain resources,

    there may be discrepancies between the reported values and actual resource utilization.

    This can occur due to Azure Monitor data delays, resource configuration issues, or temporary service interruptions.

    SETUP INSTRUCTIONS FOR AZURE CLOUD SHELL (Recommended):

    1. Learn about Azure Cloud Shell:

       Visit: https://docs.microsoft.com/en-us/azure/cloud-shell/overview

    2. Verify Azure permissions:

       Ensure your Azure AD account has "Reader" role on target subscriptions

       Additional "Reader and Data Access" role may be needed for storage metrics

       For AKS: "Azure Kubernetes Service Cluster User" role required on AKS clusters

       For Backup: "Backup Reader" role recommended for full RSV/Backup Vault visibility

    3. Access Azure Cloud Shell:

       - Login to Azure Portal with verified account

       - Open Azure Cloud Shell (PowerShell mode)

    4. Upload this script:

       Use the Cloud Shell file upload feature to upload CVAzureCloudSizingScript.ps1

    5. Run the script:

       ./CVAzureCloudSizingScript.ps1

       ./CVAzureCloudSizingScript.ps1 -Types VM,Storage

       ./CVAzureCloudSizingScript.ps1 -Types AKS

       ./CVAzureCloudSizingScript.ps1 -Types RSV,Backup,Snapshot,ASR

       ./CVAzureCloudSizingScript.ps1 -Subscriptions "Production","Development"

       ./CVAzureCloudSizingScript.ps1 -Subscriptions Production,Development -Types VM,Storage

       ./CVAzureCloudSizingScript.ps1 -ThreadCount 10

    SETUP INSTRUCTIONS FOR LOCAL SYSTEM:

    1. Install PowerShell 7:

       Download from: https://github.com/PowerShell/PowerShell/releases

    2. Install required Azure PowerShell modules:

       Install-Module Az.Accounts,Az.ResourceGraph,Az.Compute,Az.Storage,Az.Monitor,Az.Resources,Az.NetAppFiles,Az.CosmosDB,Az.Sql,Az.MySql,Az.PostgreSql,Az.Aks,Az.RecoveryServices -Force

    3. For AKS functionality, install kubectl:

       Windows: choco install kubernetes-cli  OR  winget install Kubernetes.kubectl

       macOS: brew install kubectl

       Linux: curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

              chmod +x kubectl && sudo mv kubectl /usr/local/bin/

    4. Verify Azure permissions:

       Ensure your Azure AD account has "Reader" role on target subscriptions

       For AKS: "Azure Kubernetes Service Cluster User" role required on AKS clusters

       For Backup: "Backup Reader" role recommended for full RSV/Backup Vault visibility

    5. Connect to Azure:

       Connect-AzAccount

    6. Run the script:

       .\CVAzureCloudSizingScript.ps1

       .\CVAzureCloudSizingScript.ps1 -Types VM

       .\CVAzureCloudSizingScript.ps1 -Types AKS

       .\CVAzureCloudSizingScript.ps1 -Types RSV,Backup,Snapshot,ASR

       .\CVAzureCloudSizingScript.ps1 -Subscriptions "MySubscription"

       .\CVAzureCloudSizingScript.ps1 -ThreadCount 8 -MaxRetries 5

       .\CVAzureCloudSizingScript.ps1 -SkipMetrics

    GETTING HELP:

       Get-Help .\CVAzureCloudSizingScript.ps1 -Full

       Get-Help .\CVAzureCloudSizingScript.ps1 -Examples

       .\CVAzureCloudSizingScript.ps1 -Help

#>

#Requires -Version 7.0

[CmdletBinding()]

param(

    [Parameter()]
    [string[]]$Subscriptions,

    [Parameter()]
    [string[]]$ExcludeSubscriptions,

    [Parameter()]
    [ValidateSet('VM','Storage','FileShare','NetApp','SQL','Cosmos','AKS','RSV','Backup','Snapshot','ASR', IgnoreCase = $true)]
    [string[]]$Types,

    [Parameter()]
    [ValidateRange(1,20)]
    [int]$ThreadCount = 5,

    [Parameter()]
    [ValidateRange(1,10)]
    [int]$MaxRetries = 3,

    [Parameter()]
    [string]$OutputPath = 'C:\temp',

    [Parameter()]
    [switch]$SkipMetrics,

    # Improvement #16: Renamed from -Confirm to -Interactive to avoid
    # conflict with PowerShell built-in -Confirm ShouldProcess preference
    [Parameter()]
    [switch]$Interactive,

    [Parameter()]
    [Alias('h','?')]
    [switch]$Help

)

# ============================================================================
# EARLY HELP INTERCEPTION
# ============================================================================

if ($Help) {
    Get-Help $PSCommandPath -Full
    exit 0
}

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# ============================================================================
# SECTION 0: AUTHENTICATION PRE-FLIGHT CHECK
# ============================================================================

try {
    $currentCtx = Get-AzContext -ErrorAction Stop
    if (-not $currentCtx -or -not $currentCtx.Account) {
        throw "NoContext"
    }
} catch {
    Write-Host ""
    Write-Host "ERROR: No active Azure session detected." -ForegroundColor Red
    Write-Host ""
    Write-Host "Please authenticate before running this script:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  Connect-AzAccount                              # Interactive browser login" -ForegroundColor Cyan
    Write-Host "  Connect-AzAccount -TenantId <tenant-id>        # Specific tenant" -ForegroundColor Cyan
    Write-Host "  Connect-AzAccount -Identity                    # Managed Identity (automation)" -ForegroundColor Cyan
    Write-Host "  Connect-AzAccount -ServicePrincipal ...        # Service Principal (CI/CD)" -ForegroundColor Cyan
    Write-Host ""
    exit 1
}

Write-Host "Authenticated as: $($currentCtx.Account.Id)" -ForegroundColor Green
Write-Host "Default tenant:   $($currentCtx.Tenant.Id)" -ForegroundColor Green
if ($currentCtx.Subscription) {
    Write-Host "Default sub:      $($currentCtx.Subscription.Name)" -ForegroundColor Green
}
Write-Host ""

# ============================================================================
# SECTION 0.1: ENVIRONMENT BOOTSTRAP
# ============================================================================

[System.Threading.Thread]::CurrentThread.CurrentCulture   = 'en-US'
[System.Threading.Thread]::CurrentThread.CurrentUICulture = 'en-US'

$scriptStart = Get-Date
$dateStr     = $scriptStart.ToString('yyyy-MM-dd_HHmmss')

if (-not (Test-Path $OutputPath)) {
    New-Item -ItemType Directory -Force -Path $OutputPath | Out-Null
}

$outDir = Join-Path $OutputPath "az-sizing-$dateStr"
New-Item -ItemType Directory -Force -Path $outDir | Out-Null

$logFile = Join-Path $outDir "azure_sizing_script_output_$dateStr.log"
Start-Transcript -Path $logFile -Append

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host " Azure Cloud Sizing Script v2.1  - Enhanced Backup Coverage" -ForegroundColor Cyan
Write-Host " Started: $scriptStart" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan

# ============================================================================
# SECTION 1: MODULE LOADING
# ============================================================================

$coreModules = @('Az.Accounts', 'Az.ResourceGraph', 'Az.Monitor', 'Az.Resources')

$optionalModules = @{
    VM        = @('Az.Compute')
    STORAGE   = @('Az.Storage')
    FILESHARE = @('Az.Storage')
    NETAPP    = @('Az.NetAppFiles')
    SQL       = @('Az.Sql', 'Az.MySql', 'Az.PostgreSql')
    COSMOS    = @('Az.CosmosDB')
    AKS       = @('Az.Aks')
    RSV       = @('Az.RecoveryServices')
    BACKUP    = @()
    SNAPSHOT  = @()
    ASR       = @('Az.RecoveryServices')
}

$ResourceTypeMap = @{
    VM        = 'VMs'
    STORAGE   = 'StorageAccounts'
    FILESHARE = 'FileShares'
    NETAPP    = 'NetAppVolumes'
    SQL       = 'SqlInventory'
    COSMOS    = 'CosmosDBs'
    AKS       = 'AKSClusters'
    RSV       = 'RecoveryServicesVaults'
    BACKUP    = 'BackupVaults'
    SNAPSHOT  = 'DiskSnapshots'
    ASR       = 'SiteRecovery'
}

$Selected = [PSCustomObject]@{
    VM        = $false
    STORAGE   = $false
    FILESHARE = $false
    NETAPP    = $false
    SQL       = $false
    COSMOS    = $false
    AKS       = $false
    RSV       = $false
    BACKUP    = $false
    SNAPSHOT  = $false
    ASR       = $false
}

if ($Types) {
    $Types = $Types | ForEach-Object { $_.Trim().ToUpper() }
    $invalidTypes = @()
    $anyValid = $false
    foreach ($t in $Types) {
        if ($ResourceTypeMap.ContainsKey($t)) {
            $Selected.$t = $true
            $anyValid = $true
        } else {
            $invalidTypes += $t
        }
    }
    if ($invalidTypes.Count -gt 0) {
        Write-Warning "Invalid type(s): $($invalidTypes -join ', '). Valid: VM, Storage, FileShare, NetApp, SQL, Cosmos, AKS, RSV, Backup, Snapshot, ASR"
    }
    if (-not $anyValid) {
        Write-Error "No valid -Types specified. Exiting."
        exit 1
    }
} else {
    $ResourceTypeMap.Keys | ForEach-Object { $Selected.$_ = $true }
}

$activeTypes = $ResourceTypeMap.Keys | Where-Object { $Selected.$_ }
Write-Host "Selected resource types: $($activeTypes -join ', ')" -ForegroundColor Green
Write-Host "Thread count: $ThreadCount | Max retries: $MaxRetries" -ForegroundColor Green
if ($SkipMetrics) {
    Write-Host "SkipMetrics: ON (ARG inventory only, no Azure Monitor capacity metrics)" -ForegroundColor Yellow
}

$modulesToLoad = $coreModules
foreach ($key in $ResourceTypeMap.Keys) {
    if ($Selected.$key -and $optionalModules.ContainsKey($key)) {
        $modulesToLoad += $optionalModules[$key]
    }
}
$modulesToLoad = $modulesToLoad | Sort-Object -Unique

foreach ($m in $modulesToLoad) {
    try { Import-Module $m -ErrorAction Stop }
    catch { Write-Warning "Could not load module $m : $($_.Exception.Message)" }
}

if (-not (Get-Module -ListAvailable -Name ImportExcel)) {
    Write-Host "Installing ImportExcel module for executive reporting..." -ForegroundColor Yellow
    try {
        Install-Module ImportExcel -Force -Scope CurrentUser -AllowClobber -ErrorAction Stop
    } catch {
        Write-Warning "Could not install ImportExcel. Excel report will be skipped. CSV will still be generated."
    }
}

# ============================================================================
# SECTION 2: SUBSCRIPTION DISCOVERY AND VALIDATION
# ============================================================================

Write-Host "`nDiscovering subscriptions..." -ForegroundColor Yellow

$allSubs = @(Get-AzSubscription -WarningAction SilentlyContinue -ErrorAction Stop | Where-Object { $_.State -eq 'Enabled' })

if (-not $allSubs -or $allSubs.Count -eq 0) {
    Write-Error "No active Azure subscriptions found. Ensure you are authenticated (Connect-AzAccount)."
    exit 1
}

# Apply -Subscriptions filter
if ($Subscriptions) {
    Write-Host "Filtering to requested subscriptions..." -ForegroundColor Yellow
    $filteredSubs = @()
    $notFound     = @()
    foreach ($filter in $Subscriptions) {
        $clean = $filter.Trim()
        $match = $allSubs | Where-Object {
            $_.Name -ieq $clean -or $_.Id -eq $clean -or $_.SubscriptionId -eq $clean
        }
        if ($match) {
            $filteredSubs += $match
            Write-Host "  Matched: $($match.Name) ($($match.SubscriptionId))" -ForegroundColor Green
        } else {
            $notFound += $clean
            Write-Warning "  Not found: '$clean'"
        }
    }
    if ($notFound.Count -gt 0) {
        Write-Host "`n  Available subscriptions:" -ForegroundColor Yellow
        $allSubs | ForEach-Object { Write-Host "    $($_.Name) ($($_.SubscriptionId))" -ForegroundColor DarkGray }
    }
    if ($filteredSubs.Count -eq 0) {
        Write-Error "No valid subscriptions matched. Exiting."
        exit 1
    }
    $candidateSubs = $filteredSubs
} else {
    $candidateSubs = $allSubs
}

# Apply -ExcludeSubscriptions filter
if ($ExcludeSubscriptions) {
    $beforeCount = $candidateSubs.Count
    foreach ($excl in $ExcludeSubscriptions) {
        $cleanExcl = $excl.Trim()
        $candidateSubs = @($candidateSubs | Where-Object {
            $_.Name -ine $cleanExcl -and $_.Id -ne $cleanExcl -and $_.SubscriptionId -ne $cleanExcl
        })
    }
    $removedCount = $beforeCount - $candidateSubs.Count
    if ($removedCount -gt 0) {
        Write-Host "Excluded $removedCount subscription(s) via -ExcludeSubscriptions" -ForegroundColor Yellow
    }
}

Write-Host "`n  Discovered $($candidateSubs.Count) subscription(s):" -ForegroundColor Green
Write-Host "  -------------------------------------------------------" -ForegroundColor DarkGray
for ($i = 0; $i -lt $candidateSubs.Count; $i++) {
    $num = ($i + 1).ToString().PadLeft(3)
    Write-Host "  $num  $($candidateSubs[$i].Name)" -ForegroundColor Cyan -NoNewline
    Write-Host "  ($($candidateSubs[$i].SubscriptionId))" -ForegroundColor DarkGray
}
Write-Host "  -------------------------------------------------------" -ForegroundColor DarkGray

# Improvement #16: Use -Interactive instead of -Confirm
if ($Interactive) {
    Write-Host ""
    Write-Host "  To exclude subscriptions, enter numbers, ranges, or both." -ForegroundColor Yellow
    Write-Host "  Examples:  3,7,15      (individual)" -ForegroundColor DarkGray
    Write-Host "             32-37       (range)" -ForegroundColor DarkGray
    Write-Host "             3,7,32-37   (mixed)" -ForegroundColor DarkGray
    Write-Host "  Press ENTER with no input to proceed with all listed subscriptions." -ForegroundColor Yellow
    Write-Host ""
    $excludeInput = Read-Host "  Exclude (or ENTER to continue)"

    if ($excludeInput -and $excludeInput.Trim() -ne '') {
        $excludeNums = [System.Collections.Generic.HashSet[int]]::new()
        foreach ($token in ($excludeInput -split ',')) {
            $token = $token.Trim()
            if ($token -match '^(\d+)\s*-\s*(\d+)$') {
                $rangeStart = [int]$Matches[1]
                $rangeEnd   = [int]$Matches[2]
                if ($rangeStart -gt $rangeEnd) { $rangeStart, $rangeEnd = $rangeEnd, $rangeStart }
                for ($n = $rangeStart; $n -le $rangeEnd; $n++) {
                    if ($n -ge 1 -and $n -le $candidateSubs.Count) {
                        $null = $excludeNums.Add($n)
                    }
                }
            } elseif ($token -match '^\d+$') {
                $num = [int]$token
                if ($num -ge 1 -and $num -le $candidateSubs.Count) {
                    $null = $excludeNums.Add($num)
                }
            }
        }

        if ($excludeNums.Count -gt 0) {
            $excludedNames = @()
            $remaining = @()
            for ($i = 0; $i -lt $candidateSubs.Count; $i++) {
                if ($excludeNums.Contains($i + 1)) {
                    $excludedNames += $candidateSubs[$i].Name
                } else {
                    $remaining += $candidateSubs[$i]
                }
            }
            Write-Host ""
            Write-Host "  Excluded $($excludedNames.Count) subscription(s):" -ForegroundColor DarkYellow
            foreach ($en in $excludedNames) {
                Write-Host "    $en" -ForegroundColor DarkYellow
            }
            $candidateSubs = $remaining
        }

        if ($candidateSubs.Count -eq 0) {
            Write-Error "All subscriptions were excluded. Nothing to process."
            exit 1
        }
    }
}

$targetSubs = $candidateSubs
Write-Host "`nTargeting $($targetSubs.Count) subscription(s):" -ForegroundColor Green
$targetSubs | ForEach-Object { Write-Host "  $($_.Name)" -ForegroundColor Cyan }

# ============================================================================
# SECTION 3: HELPER FUNCTIONS
# ============================================================================

# NOTE: All retry logic, metric fetching, and ARG queries are implemented
# directly inside the parallel processing block (Section 5) as self-contained
# Local: functions. This avoids PowerShell parallel scope resolution issues.

# ============================================================================
# SECTION 4: ARG QUERY DEFINITIONS
# ============================================================================

$ARGQueries = @{

    # Improvement #12: Added powerState from extended instanceView
    VM = @"
resources
| where type =~ 'microsoft.compute/virtualmachines'
| project id, name, resourceGroup, location, subscriptionId,
          vmSize = tostring(properties.hardwareProfile.vmSize),
          osType = tostring(properties.storageProfile.osDisk.osType),
          osDiskSizeGB = toint(properties.storageProfile.osDisk.diskSizeGB),
          osDiskName = tostring(properties.storageProfile.osDisk.name),
          dataDisks = properties.storageProfile.dataDisks,
          dataDiskCount = array_length(properties.storageProfile.dataDisks),
          powerState = tostring(properties.extended.instanceView.powerState.code)
"@

    # Improvement #13: diskState for orphaned disk detection
    Disks = @"
resources
| where type =~ 'microsoft.compute/disks'
| project id, name, resourceGroup, location, subscriptionId,
          diskSizeGB = toint(properties.diskSizeGB),
          diskState = tostring(properties.diskState),
          managedBy = tostring(properties.managedBy),
          skuName = tostring(sku.name),
          skuTier = tostring(sku.tier),
          timeCreated = tostring(properties.timeCreated),
          osType = tostring(properties.osType)
"@

    StorageAccounts = @"
resources
| where type =~ 'microsoft.storage/storageaccounts'
| project id, name, resourceGroup, location, subscriptionId,
          saKind = tostring(kind),
          skuName = tostring(sku['name']),
          accessTier = tostring(properties.accessTier),
          hnsEnabled = tostring(properties.isHnsEnabled),
          primaryLocation = tostring(properties.primaryLocation)
"@

    StorageAccountBlobServices = @"
resources
| where type =~ 'microsoft.storage/storageaccounts/blobservices'
| project id, name, subscriptionId,
          storageAccountId = tolower(tostring(split(id, '/blobServices/')[0])),
          blobSoftDeleteEnabled = tostring(properties.deleteRetentionPolicy.enabled),
          blobSoftDeleteDays = toint(properties.deleteRetentionPolicy.days),
          containerSoftDeleteEnabled = tostring(properties.containerDeleteRetentionPolicy.enabled),
          containerSoftDeleteDays = toint(properties.containerDeleteRetentionPolicy.days),
          blobVersioningEnabled = tostring(properties.isVersioningEnabled),
          changeFeedEnabled = tostring(properties.changeFeed.enabled)
"@

    NetAppVolumes = @"
resources
| where type =~ 'microsoft.netapp/netappaccounts/capacitypools/volumes'
| project id, name, resourceGroup, location, subscriptionId,
          usageThreshold = tolong(properties.usageThreshold),
          creationToken = tostring(properties.creationToken),
          protocolTypes = tostring(properties.protocolTypes),
          serviceLevel = tostring(properties.serviceLevel)
"@

    NetAppPools = @"
resources
| where type =~ 'microsoft.netapp/netappaccounts/capacitypools'
| project id, name, resourceGroup, location, subscriptionId,
          poolSize = tolong(properties.size),
          serviceLevel = tostring(properties.serviceLevel)
"@

    SqlServers = @"
resources
| where type =~ 'microsoft.sql/servers'
| project id, name, resourceGroup, location, subscriptionId
"@

    SqlDatabases = @"
resources
| where type =~ 'microsoft.sql/servers/databases'
| where tostring(sku['name']) != 'System'
| project id, name, resourceGroup, location, subscriptionId,
          edition = tostring(properties.edition),
          skuName = tostring(sku['name']),
          maxSizeBytes = tolong(properties.maxSizeBytes),
          status = tostring(properties.status),
          databaseId = tostring(properties.databaseId),
          elasticPoolId = tostring(properties.elasticPoolId)
"@

    SqlElasticPools = @"
resources
| where type =~ 'microsoft.sql/servers/elasticpools'
| project id, name, resourceGroup, location, subscriptionId,
          edition = tostring(properties.edition),
          state = tostring(properties.state),
          skuName = tostring(sku['name']),
          skuTier = tostring(sku['tier']),
          skuCapacity = toint(sku['capacity']),
          maxSizeBytes = tolong(properties.maxSizeBytes),
          perDbMinCapacity = toreal(properties.perDatabaseSettings.minCapacity),
          perDbMaxCapacity = toreal(properties.perDatabaseSettings.maxCapacity),
          zoneRedundant = tostring(properties.zoneRedundant),
          licenseType = tostring(properties.licenseType)
"@

    SqlManagedInstances = @"
resources
| where type =~ 'microsoft.sql/managedinstances'
| project id, name, resourceGroup, location, subscriptionId,
          vCores = toint(properties.vCores),
          storageSizeInGB = toint(properties.storageSizeInGB),
          licenseType = tostring(properties.licenseType),
          state = tostring(properties.state),
          subnetId = tostring(properties.subnetId)
"@

    MySqlFlexible = @"
resources
| where type =~ 'microsoft.dbformysql/flexibleservers'
| project id, name, resourceGroup, location, subscriptionId,
          version = tostring(properties.version),
          fqdn = tostring(properties.fullyQualifiedDomainName),
          storageSizeGB = toint(properties.storage.storageSizeGB),
          storageIops = toint(properties.storage.iops),
          skuName = tostring(sku['name']),
          backupRetention = toint(properties.backup.backupRetentionDays)
"@

    MySqlSingle = @"
resources
| where type =~ 'microsoft.dbformysql/servers'
| project id, name, resourceGroup, location, subscriptionId,
          version = tostring(properties.version),
          fqdn = tostring(properties.fullyQualifiedDomainName),
          storageMB = toint(properties.storageProfile.storageMB),
          backupRetention = toint(properties.storageProfile.backupRetentionDays),
          skuName = tostring(sku['name']),
          skuTier = tostring(sku['tier'])
"@

    PostgreSqlFlexible = @"
resources
| where type =~ 'microsoft.dbforpostgresql/flexibleservers'
| project id, name, resourceGroup, location, subscriptionId,
          version = tostring(properties.version),
          fqdn = tostring(properties.fullyQualifiedDomainName),
          storageSizeGB = toint(properties.storage.storageSizeGB),
          skuName = tostring(sku['name']),
          backupRetention = toint(properties.backup.backupRetentionDays)
"@

    PostgreSqlSingle = @"
resources
| where type =~ 'microsoft.dbforpostgresql/servers'
| project id, name, resourceGroup, location, subscriptionId,
          version = tostring(properties.version),
          fqdn = tostring(properties.fullyQualifiedDomainName),
          storageMB = toint(properties.storageProfile.storageMB),
          backupRetention = toint(properties.storageProfile.backupRetentionDays),
          skuName = tostring(sku['name']),
          skuTier = tostring(sku['tier'])
"@

    CosmosDB = @"
resources
| where type =~ 'microsoft.documentdb/databaseaccounts'
| project id, name, resourceGroup, location, subscriptionId,
          cosmosKind = tostring(kind),
          instanceId = tostring(properties.instanceId),
          minimalTlsVersion = tostring(properties.minimalTlsVersion),
          backupType = tostring(properties.backupPolicy.type),
          backupInterval = toint(properties.backupPolicy.periodicModeProperties.backupIntervalInMinutes),
          backupRetention = toint(properties.backupPolicy.periodicModeProperties.backupRetentionIntervalInHours),
          backupRedundancy = tostring(properties.backupPolicy.periodicModeProperties.backupStorageRedundancy)
"@

    AKS = @"
resources
| where type =~ 'microsoft.containerservice/managedclusters'
| project id, name, resourceGroup, location, subscriptionId,
          kubernetesVersion = tostring(properties.kubernetesVersion),
          powerState = tostring(properties.powerState.code),
          nodePoolCount = array_length(properties.agentPoolProfiles)
"@

    RSVVaults = @"
resources
| where type =~ 'microsoft.recoveryservices/vaults'
| project id, name, resourceGroup, location, subscriptionId,
          skuName = tostring(sku['name']),
          storageRedundancy = tostring(properties.redundancySettings.standardTierStorageRedundancy),
          crossRegionRestore = tostring(properties.redundancySettings.crossRegionRestore),
          provisioningState = tostring(properties.provisioningState)
"@

    RSVProtectedItems = @"
RecoveryServicesResources
| where type =~ 'microsoft.recoveryservices/vaults/backupfabrics/protectioncontainers/protecteditems'
| project id, name, subscriptionId,
          vaultName = tostring(split(split(id, '/Microsoft.RecoveryServices/vaults/')[1],'/')[0]),
          friendlyName = tostring(properties.friendlyName),
          backupManagementType = tostring(properties.backupManagementType),
          workloadType = tostring(properties.workloadType),
          protectionState = tostring(properties.protectionState),
          lastBackupStatus = tostring(properties.lastBackupStatus),
          lastBackupTime = tostring(properties.lastBackupTime),
          policyId = tostring(properties.policyId),
          sourceResourceId = tostring(properties.sourceResourceId),
          protectedItemType = tostring(properties.protectedItemType)
"@

    BackupVaults = @"
resources
| where type =~ 'microsoft.dataprotection/backupvaults'
| project id, name, resourceGroup, location, subscriptionId,
          storageType = tostring(properties.storageSettings[0].type),
          datastoreType = tostring(properties.storageSettings[0].datastoreType),
          provisioningState = tostring(properties.provisioningState)
"@

    BackupInstances = @"
RecoveryServicesResources
| where type =~ 'microsoft.dataprotection/backupvaults/backupinstances'
| project id, name, subscriptionId,
          vaultName = tostring(split(split(id, '/Microsoft.DataProtection/backupVaults/')[1],'/')[0]),
          friendlyName = tostring(properties.friendlyName),
          datasourceType = tostring(properties.dataSourceInfo.datasourceType),
          resourceName = tostring(properties.dataSourceInfo.resourceName),
          resourceId = tostring(properties.dataSourceInfo.resourceID),
          protectionStatus = tostring(properties.protectionStatus.status),
          currentProtectionState = tostring(properties.currentProtectionState)
"@

    DiskSnapshots = @"
resources
| where type =~ 'microsoft.compute/snapshots'
| project id, name, resourceGroup, location, subscriptionId,
          diskSizeGB = toint(properties.diskSizeGB),
          timeCreated = tostring(properties.timeCreated),
          sourceResourceId = tostring(properties.creationData.sourceResourceId),
          sourceType = tostring(properties.creationData.createOption),
          osType = tostring(properties.osType),
          skuName = tostring(sku.name),
          skuTier = tostring(sku.tier),
          incremental = tostring(properties.incremental),
          provisioningState = tostring(properties.provisioningState),
          networkAccessPolicy = tostring(properties.networkAccessPolicy)
"@

    ASRReplicatedItems = @"
RecoveryServicesResources
| where type =~ 'microsoft.recoveryservices/vaults/replicationfabrics/replicationprotectioncontainers/replicationprotecteditems'
| project id, name, subscriptionId,
          vaultName = tostring(split(split(id, '/Microsoft.RecoveryServices/vaults/')[1],'/')[0]),
          friendlyName = tostring(properties.friendlyName),
          protectionState = tostring(properties.protectionState),
          protectionStateDescription = tostring(properties.protectionStateDescription),
          activeLocation = tostring(properties.activeLocation),
          testFailoverState = tostring(properties.testFailoverState),
          testFailoverStateDescription = tostring(properties.testFailoverStateDescription),
          replicationHealth = tostring(properties.replicationHealth),
          failoverHealth = tostring(properties.failoverHealth),
          primaryFabricFriendlyName = tostring(properties.primaryFabricFriendlyName),
          primaryProtectionContainerFriendlyName = tostring(properties.primaryProtectionContainerFriendlyName),
          recoveryFabricFriendlyName = tostring(properties.recoveryFabricFriendlyName),
          recoveryProtectionContainerFriendlyName = tostring(properties.recoveryProtectionContainerFriendlyName),
          protectedItemType = tostring(properties.providerSpecificDetails.instanceType),
          sourceVmId = tostring(properties.providerSpecificDetails.fabricObjectId),
          targetRegion = tostring(properties.providerSpecificDetails.recoveryAzureResourceGroupId)
"@

    RSVBackupPolicies = @"
RecoveryServicesResources
| where type =~ 'microsoft.recoveryservices/vaults/backuppolicies'
| project id, name, subscriptionId,
          vaultName = tostring(split(split(id, '/Microsoft.RecoveryServices/vaults/')[1],'/')[0]),
          backupManagementType = tostring(properties.backupManagementType),
          policyType = tostring(properties.policyType),
          protectedItemsCount = toint(properties.protectedItemsCount),
          scheduleFrequency = tostring(properties.schedulePolicy.schedulePolicyType),
          scheduleRunFrequency = tostring(properties.schedulePolicy.scheduleRunFrequency),
          scheduleRunTimes = tostring(properties.schedulePolicy.scheduleRunTimes),
          retentionDailyCount = toint(properties.retentionPolicy.dailySchedule.retentionDuration.count),
          retentionDailyType = tostring(properties.retentionPolicy.dailySchedule.retentionDuration.durationType),
          retentionWeeklyCount = toint(properties.retentionPolicy.weeklySchedule.retentionDuration.count),
          retentionWeeklyType = tostring(properties.retentionPolicy.weeklySchedule.retentionDuration.durationType),
          retentionMonthlyCount = toint(properties.retentionPolicy.monthlySchedule.retentionDuration.count),
          retentionMonthlyType = tostring(properties.retentionPolicy.monthlySchedule.retentionDuration.durationType),
          retentionYearlyCount = toint(properties.retentionPolicy.yearlySchedule.retentionDuration.count),
          retentionYearlyType = tostring(properties.retentionPolicy.yearlySchedule.retentionDuration.durationType),
          instantRpDays = toint(properties.instantRpRetentionRangeInDays),
          timeZone = tostring(properties.timeZone)
"@

    # Improvement #8: VM Restore Point Collections
    RestorePointCollections = @"
resources
| where type =~ 'microsoft.compute/restorepointcollections'
| project id, name, resourceGroup, location, subscriptionId,
          sourceVmId = tostring(properties.source.id),
          provisioningState = tostring(properties.provisioningState),
          restorePointCount = array_length(properties.restorePoints)
"@

}

# ============================================================================
# SECTION 5: PER-SUBSCRIPTION PROCESSING (Parallel Execution Block)
# ============================================================================

Write-Host "`n=== Beginning Parallel Resource Discovery ===" -ForegroundColor Green
Write-Host "Processing $($targetSubs.Count) subscriptions across $ThreadCount threads...`n" -ForegroundColor Yellow

$currentContext = Get-AzContext

$subInfoList = $targetSubs | ForEach-Object {
    @{
        Id   = $_.SubscriptionId
        Name = $_.Name
    }
}

$parallelResults = $subInfoList | ForEach-Object -ThrottleLimit $ThreadCount -Parallel {

    $subInfo      = $_
    $subId        = $subInfo.Id
    $subName      = $subInfo.Name
    $selectedRef  = $using:Selected
    $maxRetries   = $using:MaxRetries
    $argQueries   = $using:ARGQueries
    $skipMetrics  = $using:SkipMetrics

    # ---- Process-scoped context isolation ----
    try {
        Set-AzContext -SubscriptionId $subId -Scope Process -ErrorAction Stop | Out-Null
    } catch {
        Write-Warning "SKIP [$subName]: Failed to set context: $($_.Exception.Message)"
        return @{
            SubscriptionName = $subName
            SubscriptionId   = $subId
            Status           = 'ContextFailed'
            Error            = $_.Exception.Message
        }
    }

    # ---- Pre-flight access check ----
    try {
        $null = Get-AzResourceGroup -ErrorAction Stop | Select-Object -First 1
    } catch {
        Write-Warning "SKIP [$subName]: Access denied or no resource groups readable."
        return @{
            SubscriptionName = $subName
            SubscriptionId   = $subId
            Status           = 'AccessDenied'
            Error            = $_.Exception.Message
        }
    }

    Write-Host "[START] $subName ($subId)" -ForegroundColor Cyan

    # ---- Local helper: Get-MetricSafe ----
    function Local:Get-MetricSafe {
        param(
            [string]$ResourceId,
            [string]$MetricName,
            [string]$AggType = 'Maximum',
            [int]$Retries = 3
        )
        $attempt = 0
        while ($attempt -lt $Retries) {
            $attempt++
            try {
                $m = Get-AzMetric -ResourceId $ResourceId -MetricName $MetricName `
                    -AggregationType $AggType -StartTime (Get-Date).AddHours(-1) `
                    -WarningAction SilentlyContinue -ErrorAction Stop
                if ($m.Data -and $m.Data.Count -gt 0) {
                    $vals = $m.Data | ForEach-Object { $_.$AggType } | Where-Object { $_ -ne $null }
                    if ($vals) { return ($vals | Select-Object -Last 1) }
                }
                return $null
            } catch {
                $errMsg = $_.Exception.Message
                $isRetryable = $errMsg -match '429' -or $errMsg -match 'throttl' -or $errMsg -match '5\d{2}' -or $errMsg -match 'service unavailable'
                if ($isRetryable -and $attempt -lt $Retries) {
                    $backoff = [math]::Pow(2, $attempt) + (Get-Random -Minimum 0 -Maximum 2000) / 1000
                    Start-Sleep -Milliseconds ([int]($backoff * 1000))
                    continue
                }
                return $null
            }
        }
        return $null
    }

    function Local:Get-MultiMetricSafe {
        param(
            [string]$ResourceId,
            [string[]]$MetricNames,
            [string]$AggType = 'Maximum',
            [int]$Retries = 3
        )
        $results = @{}
        $MetricNames | ForEach-Object { $results[$_] = $null }
        $attempt = 0
        while ($attempt -lt $Retries) {
            $attempt++
            try {
                $metrics = Get-AzMetric -ResourceId $ResourceId -MetricName $MetricNames `
                    -AggregationType $AggType -StartTime (Get-Date).AddHours(-1) `
                    -WarningAction SilentlyContinue -ErrorAction Stop
                if ($metrics) {
                    foreach ($metric in $metrics) {
                        $n = $metric.Name.Value
                        if ($metric.Data -and $metric.Data.Count -gt 0) {
                            $vals = $metric.Data | ForEach-Object { $_.$AggType } | Where-Object { $_ -ne $null }
                            if ($vals) { $results[$n] = ($vals | Select-Object -Last 1) }
                        }
                    }
                }
                return $results
            } catch {
                $errMsg = $_.Exception.Message
                $isRetryable = $errMsg -match '429' -or $errMsg -match 'throttl' -or $errMsg -match '5\d{2}' -or $errMsg -match 'service unavailable'
                if ($isRetryable -and $attempt -lt $Retries) {
                    $backoff = [math]::Pow(2, $attempt) + (Get-Random -Minimum 0 -Maximum 2000) / 1000
                    Start-Sleep -Milliseconds ([int]($backoff * 1000))
                    continue
                }
                return $results
            }
        }
        return $results
    }

    # ---- TOP-LEVEL SAFETY NET ----
    try {

    # ---- Initialize result collectors ----
    $subResults = @{
        SubscriptionName   = $subName
        SubscriptionId     = $subId
        Status             = 'Success'
        Errors             = [System.Collections.ArrayList]::new()
        VMs                = [System.Collections.ArrayList]::new()
        OrphanedDisks      = [System.Collections.ArrayList]::new()
        StorageAccounts    = [System.Collections.ArrayList]::new()
        FileShares         = [System.Collections.ArrayList]::new()
        NetAppVolumes      = [System.Collections.ArrayList]::new()
        SqlManagedInst     = [System.Collections.ArrayList]::new()
        SqlDatabases       = [System.Collections.ArrayList]::new()
        SqlElasticPools    = [System.Collections.ArrayList]::new()
        SqlBackupStorage   = [System.Collections.ArrayList]::new()
        MySQLServers       = [System.Collections.ArrayList]::new()
        PostgreSQLServers  = [System.Collections.ArrayList]::new()
        SqlMIDbInventory   = [System.Collections.ArrayList]::new()
        CosmosDBAccounts   = [System.Collections.ArrayList]::new()
        AKSClusters        = [System.Collections.ArrayList]::new()
        AKSPVs             = [System.Collections.ArrayList]::new()
        AKSPVCs            = [System.Collections.ArrayList]::new()
        RSVVaults          = [System.Collections.ArrayList]::new()
        RSVProtectedItems  = [System.Collections.ArrayList]::new()
        RSVRecoveryPoints  = [System.Collections.ArrayList]::new()
        RSVBackupPolicies  = [System.Collections.ArrayList]::new()
        BackupVaults       = [System.Collections.ArrayList]::new()
        BackupInstances    = [System.Collections.ArrayList]::new()
        BackupVaultPolicies = [System.Collections.ArrayList]::new()
        DiskSnapshots      = [System.Collections.ArrayList]::new()
        VMRestorePoints    = [System.Collections.ArrayList]::new()
        ASRReplicatedItems = [System.Collections.ArrayList]::new()
    }

    # ---- Local helper: Get-BearerToken (inside try for scope visibility) ----
    function Local:Get-BearerToken {
        try {
            $tokenObj = Get-AzAccessToken -ResourceUrl 'https://management.azure.com' -ErrorAction Stop
            $token = if ($tokenObj.Token -is [System.Security.SecureString]) {
                [System.Runtime.InteropServices.Marshal]::PtrToStringAuto(
                    [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($tokenObj.Token))
            } else { $tokenObj.Token }
            return $token
        } catch {
            return $null
        }
    }

    # ---- Local helper: Invoke-AzRestSafe (REST API calls with retry) ----
    function Local:Invoke-AzRestSafe {
        param(
            [string]$Uri,
            [string]$Method = 'GET',
            [string]$Body = $null,
            [string]$Token,
            [int]$Retries = 3
        )
        $attempt = 0
        while ($attempt -lt $Retries) {
            $attempt++
            try {
                $headers = @{
                    Authorization  = "Bearer $Token"
                    'Content-Type' = 'application/json'
                }
                $params = @{ Uri = $Uri; Method = $Method; Headers = $headers; ErrorAction = 'Stop' }
                if ($Body) { $params.Body = $Body }
                return (Invoke-RestMethod @params)
            } catch {
                $errMsg = $_.Exception.Message
                $isRetryable = $errMsg -match '429' -or $errMsg -match '5\d{2}' -or $errMsg -match 'throttl'
                if ($isRetryable -and $attempt -lt $Retries) {
                    $backoff = [math]::Pow(2, $attempt) + (Get-Random -Minimum 0 -Maximum 2000) / 1000
                    Start-Sleep -Milliseconds ([int]($backoff * 1000))
                    continue
                }
                return $null
            }
        }
        return $null
    }

    # ---- Batch Metrics API: query up to 50 resources of the same type/region in one call ----
    # Returns a hashtable keyed by resource ID, each value is a hashtable of metric name -> value
    # Returns $null on token failure so callers can fall back to individual calls if they choose.
    # Does NOT auto-fallback to individual calls — that was causing tenant-wide 429 throttle storms
    # with large resource counts (1800+ storage accounts = 5000+ individual metric calls).
    function Local:Invoke-MetricBatch {
        param(
            [Parameter(Mandatory)]
            [object[]]$Resources,
            [Parameter(Mandatory)]
            [string]$MetricNamespace,
            [Parameter(Mandatory)]
            [string[]]$MetricNames,
            [string]$AggType = 'Maximum',
            [int]$Retries = 3
        )

        $resultMap = @{}
        foreach ($r in $Resources) {
            $rId = $r.id.ToLower()
            $resultMap[$rId] = @{}
            foreach ($mn in $MetricNames) { $resultMap[$rId][$mn] = $null }
        }

        if ($skipMetrics -or $Resources.Count -eq 0) { return $resultMap }

        $byRegion = @{}
        foreach ($r in $Resources) {
            $region = $r.location.ToLower()
            if (-not $byRegion.ContainsKey($region)) { $byRegion[$region] = @() }
            $byRegion[$region] += $r
        }

        # Get bearer token once for all batches
        $token = Get-BearerToken
        if (-not $token) {
            Write-Warning "  [$subName] Batch API: token acquisition failed, falling back to individual calls"
            return $null  # Signal caller to use individual fallback
        }

        $startTime = (Get-Date).AddHours(-1).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ss.fffZ')
        $endTime   = (Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ss.fffZ')

        foreach ($region in $byRegion.Keys) {
            $regionResources = $byRegion[$region]
            # Chunk into batches of 50
            for ($i = 0; $i -lt $regionResources.Count; $i += 50) {
                $batch = $regionResources[$i..[math]::Min($i + 49, $regionResources.Count - 1)]
                $resourceIds = @($batch | ForEach-Object { $_.id })

                $batchUri = "https://$region.metrics.monitor.azure.com/subscriptions/$subId/metrics:getBatch" +
                    "?starttime=$startTime&endtime=$endTime&interval=FULL" +
                    "&metricnamespace=$MetricNamespace" +
                    "&metricnames=$($MetricNames -join ',')" +
                    "&aggregation=$($AggType.ToLower())" +
                    "&api-version=2023-10-01"

                $body = @{ resourceids = $resourceIds } | ConvertTo-Json -Compress

                $attempt = 0
                while ($attempt -lt $Retries) {
                    $attempt++
                    try {
                        $resp = Invoke-RestMethod -Uri $batchUri -Method POST -Body $body -Headers @{
                            Authorization  = "Bearer $token"
                            'Content-Type' = 'application/json'
                        } -ErrorAction Stop

                        # Parse response: each entry in .values has .resourceid and .values[].name/.timeseries
                        if ($resp.values) {
                            foreach ($entry in $resp.values) {
                                $rId = $entry.resourceid.ToLower()
                                if ($entry.values) {
                                    foreach ($metricEntry in $entry.values) {
                                        $mName = $metricEntry.name.value
                                        if ($metricEntry.timeseries -and $metricEntry.timeseries.Count -gt 0) {
                                            foreach ($ts in $metricEntry.timeseries) {
                                                if ($ts.data -and $ts.data.Count -gt 0) {
                                                    $val = $ts.data[-1].$($AggType.ToLower())
                                                    if ($null -ne $val -and $resultMap.ContainsKey($rId)) {
                                                        $resultMap[$rId][$mName] = $val
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        break  # Success, exit retry loop
                    } catch {
                        $errMsg = $_.Exception.Message
                        if (($errMsg -match '429' -or $errMsg -match '529' -or $errMsg -match '5\d{2}') -and $attempt -lt $Retries) {
                            $backoff = [math]::Pow(2, $attempt) + (Get-Random -Minimum 0 -Maximum 2000) / 1000
                            Start-Sleep -Milliseconds ([int]($backoff * 1000))
                        } else {
                            Write-Warning "  [$subName] Batch metrics failed for $MetricNamespace in $region : $($errMsg.Substring(0, [math]::Min(120, $errMsg.Length)))"
                            break
                        }
                    }
                }
            }
        }

        return $resultMap
    }

    function Local:Invoke-ARGSafe {
        param(
            [string]$Query,
            [string]$SubId,
            [string]$ResourceTypeName,
            [int]$MaxAttempts = 3,
            [int]$PageSize    = 1000
        )
        $allRows  = [System.Collections.ArrayList]::new()
        $skipRows = 0
        while ($true) {
            $page    = $null
            $attempt = 0
            while ($true) {
                $attempt++
                try {
                    if ($skipRows -gt 0) {
                        $page = Search-AzGraph -Query $Query -Subscription $SubId `
                                    -First $PageSize -Skip $skipRows -ErrorAction Stop
                    } else {
                        $page = Search-AzGraph -Query $Query -Subscription $SubId `
                                    -First $PageSize -ErrorAction Stop
                    }
                    break
                } catch {
                    $errMsg = $_.Exception.Message
                    $isAccessDenied = $errMsg -match 'AccessDenied' -or $errMsg -match 'AuthorizationFailed' -or $errMsg -match 'does not have authorization'
                    $isQueryError   = $errMsg -match 'InvalidQuery' -or $errMsg -match 'ParserFailure' -or $errMsg -match 'BadRequest'
                    $isThrottled    = $errMsg -match '429' -or $errMsg -match 'throttl'
                    $isTransient    = $errMsg -match '5\d{2}' -or $errMsg -match 'service unavailable'

                    if ($isAccessDenied) {
                        $shortErr = if ($errMsg.Length -gt 200) { $errMsg.Substring(0,200) + '...' } else { $errMsg }
                        Write-Warning "  [$subName] $ResourceTypeName : ACCESS DENIED"
                        $null = $subResults.Errors.Add("[AccessDenied] $ResourceTypeName : $shortErr")
                        return $(if ($allRows.Count) { $allRows } else { $null })
                    }
                    if ($isQueryError) {
                        $shortErr = if ($errMsg.Length -gt 200) { $errMsg.Substring(0,200) + '...' } else { $errMsg }
                        Write-Warning "  [$subName] $ResourceTypeName : QUERY ERROR"
                        $null = $subResults.Errors.Add("[QueryError] $ResourceTypeName : $shortErr")
                        return $(if ($allRows.Count) { $allRows } else { $null })
                    }
                    if (($isThrottled -or $isTransient) -and $attempt -lt $MaxAttempts) {
                        $backoff = [math]::Pow(2, $attempt) + (Get-Random -Minimum 0 -Maximum 2000) / 1000
                        Write-Warning "  [$subName] $ResourceTypeName : Retry $attempt/$MaxAttempts in $([math]::Round($backoff,1))s"
                        Start-Sleep -Milliseconds ([int]($backoff * 1000))
                        continue
                    }
                    $shortErr = if ($errMsg.Length -gt 200) { $errMsg.Substring(0,200) + '...' } else { $errMsg }
                    Write-Warning "  [$subName] $ResourceTypeName : FAILED ($shortErr)"
                    $null = $subResults.Errors.Add("[Error] $ResourceTypeName : $shortErr")
                    return $(if ($allRows.Count) { $allRows } else { $null })
                }
            }
            if (-not $page -or $page.Count -eq 0) { break }
            $null = $allRows.AddRange(@($page))
            if ($page.Count -lt $PageSize) { break }
            $skipRows += $page.Count
            Write-Host "  [$subName] $ResourceTypeName : paging ($($allRows.Count) rows so far)..." -ForegroundColor DarkGray
        }
        if ($allRows.Count -eq 0) { return $null }
        return $allRows
    }

    # ================================================================
    # VM Processing (Improvement #12: power state, #13: orphaned disks)
    # ================================================================
    if ($selectedRef.VM) {
        Write-Host "  [$subName] Discovering VMs via ARG..." -ForegroundColor DarkCyan
        try {
            $vmData = Local:Invoke-ARGSafe -Query $argQueries.VM -SubId $subId -ResourceTypeName 'VMs' -MaxAttempts $maxRetries
            $diskData = Local:Invoke-ARGSafe -Query $argQueries.Disks -SubId $subId -ResourceTypeName 'Disks' -MaxAttempts $maxRetries

            $diskLookup = @{}
            if ($diskData) {
                foreach ($d in $diskData) {
                    $vmId = $d.managedBy
                    if ($vmId) {
                        if (-not $diskLookup.ContainsKey($vmId)) { $diskLookup[$vmId] = @() }
                        $diskLookup[$vmId] += $d
                    }
                }

                # Improvement #13: Detect orphaned (unattached) disks
                foreach ($d in $diskData) {
                    if (-not $d.managedBy -and $d.diskState -eq 'Unattached') {
                        $null = $subResults.OrphanedDisks.Add([PSCustomObject]@{
                            Subscription    = $subName
                            DiskName        = $d.name
                            ResourceGroup   = $d.resourceGroup
                            Region          = $d.location
                            DiskSizeGB      = if ($d.diskSizeGB) { [int]$d.diskSizeGB } else { 0 }
                            DiskState       = $d.diskState
                            SKU             = $d.skuName
                            Tier            = $d.skuTier
                            OSType          = $d.osType
                            TimeCreated     = $d.timeCreated
                        })
                    }
                }
            }

            if ($vmData) {
                foreach ($vm in $vmData) {
                    $totalDiskGB = 0
                    $diskCount   = 0

                    $vmDisks = $diskLookup[$vm.id]
                    if ($vmDisks) {
                        foreach ($disk in $vmDisks) {
                            $diskCount++
                            if ($disk.diskSizeGB) { $totalDiskGB += [int]$disk.diskSizeGB }
                        }
                    } else {
                        if ($vm.osDiskSizeGB) {
                            $diskCount++
                            $totalDiskGB += [int]$vm.osDiskSizeGB
                        }
                        if ($vm.dataDisks) {
                            foreach ($dd in $vm.dataDisks) {
                                $diskCount++
                                if ($dd.diskSizeGB) { $totalDiskGB += [int]$dd.diskSizeGB }
                            }
                        }
                    }

                    # Improvement #12: Include power state
                    $null = $subResults.VMs.Add([PSCustomObject]@{
                        Subscription  = $subName
                        ResourceGroup = $vm.resourceGroup
                        VMName        = $vm.name
                        VMSize        = $vm.vmSize
                        OS            = $vm.osType
                        Region        = $vm.location
                        PowerState    = $vm.powerState
                        DiskCount     = $diskCount
                        VMDiskSizeGB  = $totalDiskGB
                    })
                }
                Write-Host "  [$subName] VMs: $($vmData.Count) found" -ForegroundColor Green
                if ($subResults.OrphanedDisks.Count -gt 0) {
                    Write-Host "  [$subName] Orphaned Disks: $($subResults.OrphanedDisks.Count) found" -ForegroundColor Yellow
                }
            }
        } catch {
            Write-Warning "  [$subName] VM discovery failed: $($_.Exception.Message)"
        }
    }

    # ================================================================
    # Storage Accounts (Improvement #11: Full service breakdown)
    # ================================================================
    if ($selectedRef.STORAGE -or $selectedRef.FILESHARE) {
        Write-Host "  [$subName] Discovering Storage Accounts via ARG..." -ForegroundColor DarkCyan
        try {
            $saData = Local:Invoke-ARGSafe -Query $argQueries.StorageAccounts -SubId $subId -ResourceTypeName 'StorageAccounts' -MaxAttempts $maxRetries

            $blobSvcData = Local:Invoke-ARGSafe -Query $argQueries.StorageAccountBlobServices -SubId $subId -ResourceTypeName 'BlobServices' -MaxAttempts $maxRetries
            $blobSvcLookup = @{}
            if ($blobSvcData) {
                foreach ($bs in $blobSvcData) {
                    if ($bs.storageAccountId) { $blobSvcLookup[$bs.storageAccountId] = $bs }
                }
            }

            if ($saData) {
                $saMetricMap = $null
                if ($selectedRef.STORAGE -and -not $skipMetrics) {
                    Write-Host "  [$subName] Fetching storage metrics via Batch API ($($saData.Count) accounts)..." -ForegroundColor DarkCyan
                    $saMetricMap = Local:Invoke-MetricBatch -Resources $saData `
                        -MetricNamespace 'microsoft.storage/storageaccounts' `
                        -MetricNames @('UsedCapacity') -AggType 'Maximum'
                }

                # Improvement #11: Build sub-resource objects for batch blob/file/table/queue metrics
                # These use sub-resource IDs (e.g., /blobServices/default) grouped by service type.
                # Each service type is a separate batch call (different metric namespace).
                $blobMetricMap = @{}; $fileMetricMap = @{}; $tableMetricMap = @{}; $queueMetricMap = @{}
                if ($selectedRef.STORAGE -and -not $skipMetrics) {
                    # Blob sub-resource metrics (BlobCapacity, ContainerCount, BlobCount)
                    $blobSubResources = $saData | ForEach-Object {
                        [PSCustomObject]@{ id = "$($_.id)/blobServices/default"; location = $_.location }
                    }
                    $blobBatch = Local:Invoke-MetricBatch -Resources $blobSubResources `
                        -MetricNamespace 'microsoft.storage/storageaccounts/blobservices' `
                        -MetricNames @('BlobCapacity','ContainerCount','BlobCount') -AggType 'Maximum'
                    if ($blobBatch) { $blobMetricMap = $blobBatch }

                    # File sub-resource metrics (FileCapacity)
                    # Only attempt for account types that support Azure Files
                    $fileEligible = @($saData | Where-Object { $_.saKind -notin @('BlobStorage','BlockBlobStorage') -and $_.hnsEnabled -ne 'true' })
                    if ($fileEligible.Count -gt 0) {
                        $fileSubResources = $fileEligible | ForEach-Object {
                            [PSCustomObject]@{ id = "$($_.id)/fileServices/default"; location = $_.location }
                        }
                        $fileBatch = Local:Invoke-MetricBatch -Resources $fileSubResources `
                            -MetricNamespace 'microsoft.storage/storageaccounts/fileservices' `
                            -MetricNames @('FileCapacity') -AggType 'Maximum'
                        if ($fileBatch) { $fileMetricMap = $fileBatch }
                    }

                    # Table sub-resource metrics (TableCapacity)
                    $tableSubResources = $saData | ForEach-Object {
                        [PSCustomObject]@{ id = "$($_.id)/tableServices/default"; location = $_.location }
                    }
                    $tableBatch = Local:Invoke-MetricBatch -Resources $tableSubResources `
                        -MetricNamespace 'microsoft.storage/storageaccounts/tableservices' `
                        -MetricNames @('TableCapacity') -AggType 'Maximum'
                    if ($tableBatch) { $tableMetricMap = $tableBatch }

                    # Queue sub-resource metrics (QueueCapacity)
                    $queueSubResources = $saData | ForEach-Object {
                        [PSCustomObject]@{ id = "$($_.id)/queueServices/default"; location = $_.location }
                    }
                    $queueBatch = Local:Invoke-MetricBatch -Resources $queueSubResources `
                        -MetricNamespace 'microsoft.storage/storageaccounts/queueservices' `
                        -MetricNames @('QueueCapacity') -AggType 'Maximum'
                    if ($queueBatch) { $queueMetricMap = $queueBatch }
                }

                foreach ($sa in $saData) {
                    if ($selectedRef.STORAGE) {
                        $totalBytes = 0
                        if ($saMetricMap) {
                            $key = $sa.id.ToLower()
                            if ($saMetricMap.ContainsKey($key) -and $saMetricMap[$key]['UsedCapacity']) {
                                $totalBytes = [double]$saMetricMap[$key]['UsedCapacity']
                            }
                        } elseif (-not $skipMetrics) {
                            # Fallback to individual call if batch failed
                            try { $uc = Local:Get-MetricSafe -ResourceId $sa.id -MetricName 'UsedCapacity'
                                if ($uc) { $totalBytes = [double]$uc }
                            } catch { }
                        }

                        # Improvement #11: Look up service-level breakdown from batch results
                        $blobCapacity = $null; $containerCount = $null; $blobCount = $null
                        $fileCapacity = $null; $tableCapacity = $null; $queueCapacity = $null

                        $blobKey = "$($sa.id)/blobServices/default".ToLower()
                        if ($blobMetricMap.Count -gt 0 -and $blobMetricMap.ContainsKey($blobKey)) {
                            $blobCapacity   = $blobMetricMap[$blobKey]['BlobCapacity']
                            $containerCount = $blobMetricMap[$blobKey]['ContainerCount']
                            $blobCount      = $blobMetricMap[$blobKey]['BlobCount']
                        } elseif (-not $skipMetrics) {
                            # Fallback: individual blob metrics (original behavior)
                            try {
                                $blobMetrics = Local:Get-MultiMetricSafe -ResourceId "$($sa.id)/blobServices/default" `
                                    -MetricNames @('BlobCapacity','ContainerCount','BlobCount') -AggType 'Maximum'
                                if ($blobMetrics) {
                                    $blobCapacity   = $blobMetrics['BlobCapacity']
                                    $containerCount = $blobMetrics['ContainerCount']
                                    $blobCount      = $blobMetrics['BlobCount']
                                }
                            } catch { }
                        }

                        $fileKey = "$($sa.id)/fileServices/default".ToLower()
                        if ($fileMetricMap.Count -gt 0 -and $fileMetricMap.ContainsKey($fileKey)) {
                            $fileCapacity = $fileMetricMap[$fileKey]['FileCapacity']
                        }

                        $tableKey = "$($sa.id)/tableServices/default".ToLower()
                        if ($tableMetricMap.Count -gt 0 -and $tableMetricMap.ContainsKey($tableKey)) {
                            $tableCapacity = $tableMetricMap[$tableKey]['TableCapacity']
                        }

                        $queueKey = "$($sa.id)/queueServices/default".ToLower()
                        if ($queueMetricMap.Count -gt 0 -and $queueMetricMap.ContainsKey($queueKey)) {
                            $queueCapacity = $queueMetricMap[$queueKey]['QueueCapacity']
                        }

                        $blobBytes  = if ($blobCapacity) { [double]$blobCapacity } else { 0 }
                        $fileBytes  = if ($fileCapacity) { [double]$fileCapacity } else { 0 }
                        $tableBytes = if ($tableCapacity) { [double]$tableCapacity } else { 0 }
                        $queueBytes = if ($queueCapacity) { [double]$queueCapacity } else { 0 }

                        $bsKey = $sa.id.ToLower()
                        $bs = if ($blobSvcLookup.ContainsKey($bsKey)) { $blobSvcLookup[$bsKey] } else { $null }

                        $null = $subResults.StorageAccounts.Add([PSCustomObject]@{
                            StorageAccount             = $sa.name
                            StorageAccountType         = $sa.saKind
                            'HNSEnabled(ADLSGen2)'     = $sa.hnsEnabled
                            StorageAccountSkuName      = $sa.skuName
                            StorageAccountAccessTier   = $sa.accessTier
                            Subscription               = $subName
                            Region                     = $sa.primaryLocation
                            ResourceGroup              = $sa.resourceGroup
                            UsedCapacityBytes          = $totalBytes
                            UsedCapacityGiB            = [math]::Round($totalBytes / 1073741824, 0)
                            UsedCapacityTiB            = [math]::Round($totalBytes / 1073741824 / 1024, 4)
                            UsedCapacityGB             = [math]::Round($totalBytes / 1e9, 3)
                            UsedCapacityTB             = [math]::Round($totalBytes / 1e12, 4)
                            UsedBlobCapacityBytes      = $blobBytes
                            UsedBlobCapacityGiB        = [math]::Round($blobBytes / 1073741824, 0)
                            UsedBlobCapacityTiB        = [math]::Round($blobBytes / 1073741824 / 1024, 4)
                            UsedBlobCapacityGB         = [math]::Round($blobBytes / 1e9, 3)
                            UsedBlobCapacityTB         = [math]::Round($blobBytes / 1e12, 4)
                            UsedFileCapacityBytes      = $fileBytes
                            UsedFileCapacityGB         = [math]::Round($fileBytes / 1e9, 3)
                            UsedTableCapacityBytes     = $tableBytes
                            UsedTableCapacityGB        = [math]::Round($tableBytes / 1e9, 3)
                            UsedQueueCapacityBytes     = $queueBytes
                            UsedQueueCapacityGB        = [math]::Round($queueBytes / 1e9, 3)
                            BlobContainerCount         = $containerCount
                            BlobCount                  = $blobCount
                            BlobSoftDeleteEnabled      = if ($bs) { $bs.blobSoftDeleteEnabled } else { '' }
                            BlobSoftDeleteDays         = if ($bs) { $bs.blobSoftDeleteDays } else { $null }
                            ContainerSoftDeleteEnabled = if ($bs) { $bs.containerSoftDeleteEnabled } else { '' }
                            ContainerSoftDeleteDays    = if ($bs) { $bs.containerSoftDeleteDays } else { $null }
                            BlobVersioningEnabled      = if ($bs) { $bs.blobVersioningEnabled } else { '' }
                            ChangeFeedEnabled          = if ($bs) { $bs.changeFeedEnabled } else { '' }
                        })
                    }

                    # File Shares (Improvement #10: snapshot count via REST)
                    if ($selectedRef.FILESHARE) {
                        if ($sa.saKind -in @('BlobStorage','BlockBlobStorage')) { continue }
                        if ($sa.hnsEnabled -eq 'true') { continue }
                        try {
                            $shares = Get-AzRmStorageShare -ResourceGroupName $sa.resourceGroup -StorageAccountName $sa.name -ErrorAction SilentlyContinue
                            if ($shares) {
                                # Improvement #10: Get snapshot counts via REST API
                                $shareSnapshots = @{}
                                try {
                                    $token = Local:Get-BearerToken
                                    if ($token) {
                                        $listSharesUri = "https://management.azure.com$($sa.id)/fileServices/default/shares?api-version=2023-01-01&`$expand=snapshots"
                                        $shareListResp = Local:Invoke-AzRestSafe -Uri $listSharesUri -Token $token
                                        if ($shareListResp -and $shareListResp.value) {
                                            foreach ($s in $shareListResp.value) {
                                                $sName = $s.name
                                                $snapCount = 0
                                                if ($s.properties.snapshotTime) { $snapCount++ }
                                                # Count via metadata if available
                                                if ($s.properties.metadata -and $s.properties.metadata.'snapshot-count') {
                                                    $snapCount = [int]$s.properties.metadata.'snapshot-count'
                                                }
                                                $shareSnapshots[$sName] = $snapCount
                                            }
                                        }
                                    }
                                } catch { }

                                foreach ($share in $shares) {
                                    $usedBytes = 0
                                    $shareTier = 'Unknown'
                                    $targetObj = $share
                                    try {
                                        $detail = Get-AzRmStorageShare -ResourceGroupName $sa.resourceGroup `
                                            -StorageAccountName $sa.name -Name $share.Name -GetShareUsage -ErrorAction Stop
                                        if ($detail.ShareUsageBytes) { $usedBytes = [double]$detail.ShareUsageBytes }
                                        $targetObj = $detail
                                    } catch { }

                                    if ($targetObj.PSObject.Properties.Name -contains 'AccessTier' -and $targetObj.AccessTier) {
                                        $shareTier = $targetObj.AccessTier
                                    }

                                    $snapCount = if ($shareSnapshots.ContainsKey($share.Name)) { $shareSnapshots[$share.Name] } else { $null }

                                    $null = $subResults.FileShares.Add([PSCustomObject]@{
                                        Name                     = $targetObj.Name
                                        StorageAccount           = $sa.name
                                        StorageAccountType       = $sa.saKind
                                        StorageAccountSkuName    = $sa.skuName
                                        StorageAccountAccessTier = $sa.accessTier
                                        ShareTier                = $shareTier
                                        Subscription             = $subName
                                        Region                   = $sa.primaryLocation
                                        ProtocolType             = if ($targetObj.EnabledProtocols) { $targetObj.EnabledProtocols -join ', ' } elseif ($sa.saKind -eq 'StorageV2') { 'SMB' } else { '' }
                                        QuotaGiB                 = $targetObj.QuotaGiB
                                        QuotaTiB                 = [math]::Round($targetObj.QuotaGiB / 1024, 3)
                                        QuotaGB                  = [math]::Round($targetObj.QuotaGiB * 1.073741824, 2)
                                        QuotaTB                  = [math]::Round(($targetObj.QuotaGiB * 1.073741824) / 1000, 4)
                                        UsedCapacityBytes        = $usedBytes
                                        UsedCapacityGiB          = [math]::Round($usedBytes / 1073741824, 0)
                                        UsedCapacityTiB          = [math]::Round($usedBytes / 1073741824 / 1024, 4)
                                        UsedCapacityGB           = [math]::Round($usedBytes / 1e9, 3)
                                        UsedCapacityTB           = [math]::Round($usedBytes / 1e12, 4)
                                        SnapshotCount            = $snapCount
                                    })
                                }
                            }
                        } catch { }
                    }
                }

                if ($selectedRef.STORAGE) {
                    Write-Host "  [$subName] Storage Accounts: $($subResults.StorageAccounts.Count) found" -ForegroundColor Green
                }
                if ($selectedRef.FILESHARE) {
                    Write-Host "  [$subName] File Shares: $($subResults.FileShares.Count) found" -ForegroundColor Green
                }
            }
        } catch {
            Write-Warning "  [$subName] Storage discovery failed: $($_.Exception.Message)"
        }
    }

    # ================================================================
    # NetApp Files (ARG + Monitor)
    # ================================================================
    if ($selectedRef.NETAPP) {
        Write-Host "  [$subName] Discovering NetApp volumes via ARG..." -ForegroundColor DarkCyan
        try {
            $anfVolumes = Local:Invoke-ARGSafe -Query $argQueries.NetAppVolumes -SubId $subId -ResourceTypeName 'NetAppVolumes' -MaxAttempts $maxRetries
            $anfPools = Local:Invoke-ARGSafe -Query $argQueries.NetAppPools -SubId $subId -ResourceTypeName 'NetAppPools' -MaxAttempts $maxRetries

            $poolLookup = @{}
            if ($anfPools) { foreach ($p in $anfPools) { $poolLookup[$p.id] = $p } }

            if ($anfVolumes) {
                $anfMetricMap = $null
                if (-not $skipMetrics) {
                    Write-Host "  [$subName] Fetching NetApp metrics via Batch API ($($anfVolumes.Count) volumes)..." -ForegroundColor DarkCyan
                    $anfMetricMap = Local:Invoke-MetricBatch -Resources $anfVolumes `
                        -MetricNamespace 'microsoft.netapp/netappaccounts/capacitypools/volumes' `
                        -MetricNames @('VolumeLogicalSize') -AggType 'Average'
                }

                foreach ($vol in $anfVolumes) {
                    $usedBytes = 0
                    $key = $vol.id.ToLower()
                    if ($anfMetricMap -and $anfMetricMap.ContainsKey($key) -and $anfMetricMap[$key]['VolumeLogicalSize']) {
                        $usedBytes = [double]$anfMetricMap[$key]['VolumeLogicalSize']
                    } elseif (-not $skipMetrics) {
                        $ub = Local:Get-MetricSafe -ResourceId $vol.id -MetricName 'VolumeLogicalSize' -AggType 'Average'
                        if ($ub) { $usedBytes = [double]$ub }
                    }

                    $provBytes = if ($vol.usageThreshold) { [long]$vol.usageThreshold } else { 0 }
                    $nameParts = $vol.name -split '/'
                    $volName   = $nameParts[-1]
                    $poolName  = if ($nameParts.Count -ge 3) { $nameParts[-2] } else { '' }
                    $acctName  = if ($nameParts.Count -ge 3) { $nameParts[0] } else { '' }

                    $poolSize = 0; $poolSvcLvl = $vol.serviceLevel
                    foreach ($pKey in $poolLookup.Keys) {
                        if ($pKey -match "$acctName.*$poolName") {
                            $poolSize   = $poolLookup[$pKey].poolSize
                            $poolSvcLvl = $poolLookup[$pKey].serviceLevel
                            break
                        }
                    }

                    $null = $subResults.NetAppVolumes.Add([PSCustomObject]@{
                        VolumeName       = $volName
                        VolumeFullPath   = $vol.name
                        ResourceGroup    = $vol.resourceGroup
                        Subscription     = $subName
                        Region           = $vol.location
                        NetAppAccount    = $acctName
                        CapacityPool     = $poolName
                        ProtocolType     = $vol.protocolTypes
                        FilePath         = $vol.creationToken
                        ProvisionedGiB   = [math]::Round($provBytes / 1GB, 2)
                        ProvisionedTiB   = [math]::Round($provBytes / 1TB, 4)
                        ProvisionedGB    = [math]::Round($provBytes / 1e9, 2)
                        ProvisionedTB    = [math]::Round($provBytes / 1e12, 4)
                        UsedCapacityBytes = $usedBytes
                        UsedCapacityGiB  = [math]::Round($usedBytes / 1GB, 2)
                        UsedCapacityTiB  = [math]::Round($usedBytes / 1TB, 4)
                        UsedCapacityGB   = [math]::Round($usedBytes / 1e9, 2)
                        UsedCapacityTB   = [math]::Round($usedBytes / 1e12, 4)
                        ServiceLevel     = $poolSvcLvl
                        PoolSizeGiB      = [math]::Round($poolSize / 1GB, 2)
                        PoolSizeTiB      = [math]::Round($poolSize / 1TB, 4)
                        PoolSizeGB       = [math]::Round($poolSize / 1e9, 2)
                        PoolSizeTB       = [math]::Round($poolSize / 1e12, 4)
                    })
                }
                Write-Host "  [$subName] NetApp Volumes: $($anfVolumes.Count) found" -ForegroundColor Green
            }
        } catch {
            Write-Warning "  [$subName] NetApp discovery failed: $($_.Exception.Message)"
        }
    }


    # ================================================================
    # SQL Managed Instances + Databases + Elastic Pools
    # Improvement #5: SQL backup storage metrics
    # Improvement #15: Parallelized MI DB inventory note (still sequential
    #   per MI for correctness, but batched metric fetch reduces API calls)
    # ================================================================
    if ($selectedRef.SQL) {
        Write-Host "  [$subName] Discovering SQL resources via ARG..." -ForegroundColor DarkCyan

        # SQL Managed Instances
        try {
            $sqlMIs = Local:Invoke-ARGSafe -Query $argQueries.SqlManagedInstances -SubId $subId -ResourceTypeName 'SqlManagedInstances' -MaxAttempts $maxRetries
            if ($sqlMIs) {
                $miMetricMap = $null
                if (-not $skipMetrics) {
                    $miMetricMap = Local:Invoke-MetricBatch -Resources $sqlMIs `
                        -MetricNamespace 'microsoft.sql/managedinstances' `
                        -MetricNames @('storage_space_used_mb','reserved_storage_mb') -AggType 'Maximum'
                }

                foreach ($mi in $sqlMIs) {
                    $usedMB = 0; $allocMB = 0
                    $key = $mi.id.ToLower()
                    if ($miMetricMap -and $miMetricMap.ContainsKey($key)) {
                        if ($miMetricMap[$key]['storage_space_used_mb']) { $usedMB = [double]$miMetricMap[$key]['storage_space_used_mb'] }
                        if ($miMetricMap[$key]['reserved_storage_mb']) { $allocMB = [double]$miMetricMap[$key]['reserved_storage_mb'] }
                    } elseif (-not $skipMetrics) {
                        $fb = Local:Get-MultiMetricSafe -ResourceId $mi.id -MetricNames @('storage_space_used_mb','reserved_storage_mb')
                        if ($fb['storage_space_used_mb']) { $usedMB = [double]$fb['storage_space_used_mb'] }
                        if ($fb['reserved_storage_mb']) { $allocMB = [double]$fb['reserved_storage_mb'] }
                    }
                    $usedBytes = $usedMB * 1048576.0
                    $allocBytes = $allocMB * 1048576.0

                    $null = $subResults.SqlManagedInst.Add([PSCustomObject]@{
                        Subscription       = $subName
                        ResourceGroup      = $mi.resourceGroup
                        ManagedInstanceName = $mi.name
                        Region             = $mi.location
                        vCores             = $mi.vCores
                        StorageSizeGB      = $mi.storageSizeInGB
                        StorageUsedMB      = $usedMB
                        StorageUsedGB      = [math]::Round($usedBytes / 1e9, 2)
                        StorageUsedTiB     = [math]::Round($usedBytes / 1099511627776, 4)
                        StorageUsedTB      = [math]::Round($usedBytes / 1e12, 4)
                        StorageAllocatedGB  = [math]::Round($allocBytes / 1e9, 2)
                        StorageAllocatedTiB = [math]::Round($allocBytes / 1099511627776, 4)
                        StorageAllocatedTB  = [math]::Round($allocBytes / 1e12, 4)
                        LicenseType        = $mi.licenseType
                        State              = $mi.state
                        SubnetId           = $mi.subnetId
                    })

                    # MI Database inventory
                    try {
                        $miDbs = Get-AzSqlInstanceDatabase -InstanceName $mi.name `
                            -ResourceGroupName $mi.resourceGroup -ErrorAction Stop
                        $systemDbs = @('master','msdb','tempdb','model')
                        foreach ($miDb in $miDbs) {
                            if ($miDb.Name -in $systemDbs) { continue }
                            $ltrJson = ''; $strJson = ''
                            try {
                                $ltr = Get-AzSqlInstanceDatabaseBackupLongTermRetentionPolicy `
                                    -InstanceName $mi.name -DatabaseName $miDb.Name `
                                    -ResourceGroupName $mi.resourceGroup -ErrorAction Stop
                                $ltrJson = $ltr | ConvertTo-Json -Compress -ErrorAction SilentlyContinue
                            } catch { }
                            try {
                                $str = Get-AzSqlInstanceDatabaseBackupShortTermRetentionPolicy `
                                    -InstanceName $mi.name -DatabaseName $miDb.Name `
                                    -ResourceGroupName $mi.resourceGroup -ErrorAction Stop
                                $strJson = $str | ConvertTo-Json -Compress -ErrorAction SilentlyContinue
                            } catch { }

                            $null = $subResults.SqlMIDbInventory.Add([PSCustomObject]@{
                                Subscription          = $subName
                                ResourceGroup         = $mi.resourceGroup
                                ManagedInstanceName   = $mi.name
                                DatabaseName          = $miDb.Name
                                Status                = $miDb.Status
                                CreationDate          = $miDb.CreationDate
                                Collation             = $miDb.Collation
                                Region                = $mi.location
                                LongTermRetentionPolicyJson  = $ltrJson
                                ShortTermRetentionPolicyJson = $strJson
                            })
                        }
                    } catch {
                        Write-Verbose "  [$subName] MI DB inventory for $($mi.name) failed: $($_.Exception.Message)"
                    }
                }
                Write-Host "  [$subName] SQL Managed Instances: $($sqlMIs.Count)" -ForegroundColor Green
            }
        } catch {
            Write-Warning "  [$subName] SQL MI discovery failed: $($_.Exception.Message)"
        }

        # SQL Databases
        try {
            $sqlDBs = Local:Invoke-ARGSafe -Query $argQueries.SqlDatabases -SubId $subId -ResourceTypeName 'SqlDatabases' -MaxAttempts $maxRetries
            if ($sqlDBs) {
                $dbMetricMap = $null
                if (-not $skipMetrics) {
                    Write-Host "  [$subName] Fetching SQL DB metrics via Batch API ($($sqlDBs.Count) databases)..." -ForegroundColor DarkCyan
                    $dbMetricMap = Local:Invoke-MetricBatch -Resources $sqlDBs `
                        -MetricNamespace 'microsoft.sql/servers/databases' `
                        -MetricNames @('allocated_data_storage','storage') -AggType 'Maximum'
                }

                foreach ($db in $sqlDBs) {
                    $allocBytes = $null; $usedBytes = $null
                    $key = $db.id.ToLower()
                    if ($dbMetricMap -and $dbMetricMap.ContainsKey($key)) {
                        if ($dbMetricMap[$key]['allocated_data_storage']) { $allocBytes = [double]$dbMetricMap[$key]['allocated_data_storage'] }
                        if ($dbMetricMap[$key]['storage']) { $usedBytes = [double]$dbMetricMap[$key]['storage'] }
                    } elseif (-not $skipMetrics) {
                        $fallback = Local:Get-MultiMetricSafe -ResourceId $db.id -MetricNames @('allocated_data_storage','storage')
                        if ($fallback['allocated_data_storage']) { $allocBytes = [double]$fallback['allocated_data_storage'] }
                        if ($fallback['storage']) { $usedBytes = [double]$fallback['storage'] }
                    }

                    $maxBytes = if ($db.maxSizeBytes) { [long]$db.maxSizeBytes } else { 0 }
                    $pctUsed = $null
                    if ($usedBytes -and $allocBytes -and $allocBytes -gt 0) {
                        $pctUsed = [math]::Round(($usedBytes / $allocBytes) * 100, 2)
                    } elseif ($usedBytes -and $maxBytes -gt 0) {
                        $pctUsed = [math]::Round(($usedBytes / $maxBytes) * 100, 2)
                    }

                    $parts      = $db.name -split '/'
                    $serverName = if ($parts.Count -ge 2) { $parts[0] } else { '' }
                    $dbName     = if ($parts.Count -ge 2) { $parts[1] } else { $db.name }

                    $ltrWeekly = $null; $ltrMonthly = $null; $pitrDays = $null
                    try {
                        $ltr = Get-AzSqlDatabaseBackupLongTermRetentionPolicy `
                            -ServerName $serverName -DatabaseName $dbName `
                            -ResourceGroupName $db.resourceGroup -ErrorAction Stop
                        $ltrWeekly  = $ltr.WeeklyRetention
                        $ltrMonthly = $ltr.MonthlyRetention
                    } catch { }
                    try {
                        $str = Get-AzSqlDatabaseBackupShortTermRetentionPolicy `
                            -ServerName $serverName -DatabaseName $dbName `
                            -ResourceGroupName $db.resourceGroup -ErrorAction Stop
                        $pitrDays = $str.RetentionDays
                    } catch { }

                    $epName = ''
                    $epId   = $db.elasticPoolId
                    if ($epId) { $epParts = $epId -split '/'; $epName = $epParts[-1] }

                    $null = $subResults.SqlDatabases.Add([PSCustomObject]@{
                        Subscription    = $subName
                        ResourceGroup   = $db.resourceGroup
                        Server          = $serverName
                        Database        = $dbName
                        Edition         = $db.edition
                        InstanceType    = $db.skuName
                        ElasticPoolName = $epName
                        ElasticPoolId   = $epId
                        MaxSizeGiB      = [math]::Round($maxBytes / 1073741824, 0)
                        MaxSizeGB       = [math]::Round($maxBytes / 1e9, 3)
                        Region          = $db.location
                        DatabaseId      = $db.databaseId
                        Status          = $db.status
                        Allocated_Bytes = $allocBytes
                        Utilized_Bytes  = $usedBytes
                        Allocated_GB    = if ($allocBytes) { [math]::Round($allocBytes / 1e9, 3) } else { $null }
                        Utilized_GB     = if ($usedBytes) { [math]::Round($usedBytes / 1e9, 3) } else { $null }
                        PercentUsed     = $pctUsed
                        LTRWeeklyRetention  = $ltrWeekly
                        LTRMonthlyRetention = $ltrMonthly
                        PITR_Days           = $pitrDays
                    })
                }
                Write-Host "  [$subName] SQL Databases: $($sqlDBs.Count)" -ForegroundColor Green
            }
        } catch {
            Write-Warning "  [$subName] SQL DB discovery failed: $($_.Exception.Message)"
        }

        # Improvement #5: SQL Server-level backup storage consumption
        try {
            $sqlServers = Local:Invoke-ARGSafe -Query $argQueries.SqlServers -SubId $subId -ResourceTypeName 'SqlServers' -MaxAttempts $maxRetries
            if ($sqlServers -and -not $skipMetrics) {
                Write-Host "  [$subName] Fetching SQL backup storage metrics ($($sqlServers.Count) servers)..." -ForegroundColor DarkCyan
                foreach ($srv in $sqlServers) {
                    try {
                        $bkMetrics = Local:Get-MultiMetricSafe -ResourceId $srv.id `
                            -MetricNames @('database_backup_storage_used') -AggType 'Maximum'
                        $bkUsed = $bkMetrics['database_backup_storage_used']
                        if ($bkUsed) {
                            $null = $subResults.SqlBackupStorage.Add([PSCustomObject]@{
                                Subscription       = $subName
                                ServerName         = $srv.name
                                ResourceGroup      = $srv.resourceGroup
                                Region             = $srv.location
                                BackupStorageBytes = [double]$bkUsed
                                BackupStorageGB    = [math]::Round([double]$bkUsed / 1e9, 3)
                                BackupStorageTB    = [math]::Round([double]$bkUsed / 1e12, 4)
                            })
                        }
                    } catch { }
                }
                if ($subResults.SqlBackupStorage.Count -gt 0) {
                    Write-Host "  [$subName] SQL Backup Storage: $($subResults.SqlBackupStorage.Count) servers with data" -ForegroundColor Green
                }
            }
        } catch {
            Write-Warning "  [$subName] SQL backup storage discovery failed: $($_.Exception.Message)"
        }

        # SQL Elastic Pools
        try {
            $sqlEPs = Local:Invoke-ARGSafe -Query $argQueries.SqlElasticPools -SubId $subId -ResourceTypeName 'SqlElasticPools' -MaxAttempts $maxRetries
            if ($sqlEPs) {
                $epMetricMap = $null
                if (-not $skipMetrics) {
                    $epMetricMap = Local:Invoke-MetricBatch -Resources $sqlEPs `
                        -MetricNamespace 'microsoft.sql/servers/elasticpools' `
                        -MetricNames @('allocated_data_storage','storage_used','storage_percent','eDTU_used','cpu_percent') -AggType 'Maximum'
                }

                foreach ($ep in $sqlEPs) {
                    $epAllocBytes = $null; $epUsedBytes = $null; $epStoragePct = $null; $epDtuUsed = $null; $epCpuPct = $null
                    $key = $ep.id.ToLower()
                    if ($epMetricMap -and $epMetricMap.ContainsKey($key)) {
                        if ($epMetricMap[$key]['allocated_data_storage']) { $epAllocBytes = [double]$epMetricMap[$key]['allocated_data_storage'] }
                        if ($epMetricMap[$key]['storage_used'])           { $epUsedBytes  = [double]$epMetricMap[$key]['storage_used'] }
                        if ($epMetricMap[$key]['storage_percent'])        { $epStoragePct = [double]$epMetricMap[$key]['storage_percent'] }
                        if ($epMetricMap[$key]['eDTU_used'])              { $epDtuUsed    = [double]$epMetricMap[$key]['eDTU_used'] }
                        if ($epMetricMap[$key]['cpu_percent'])            { $epCpuPct     = [double]$epMetricMap[$key]['cpu_percent'] }
                    } elseif (-not $skipMetrics) {
                        $fb = Local:Get-MultiMetricSafe -ResourceId $ep.id -MetricNames @('allocated_data_storage','storage_used','storage_percent','eDTU_used','cpu_percent')
                        if ($fb['allocated_data_storage']) { $epAllocBytes = [double]$fb['allocated_data_storage'] }
                        if ($fb['storage_used'])           { $epUsedBytes  = [double]$fb['storage_used'] }
                        if ($fb['storage_percent'])        { $epStoragePct = [double]$fb['storage_percent'] }
                        if ($fb['eDTU_used'])              { $epDtuUsed    = [double]$fb['eDTU_used'] }
                        if ($fb['cpu_percent'])            { $epCpuPct     = [double]$fb['cpu_percent'] }
                    }

                    $epMaxBytes = if ($ep.maxSizeBytes) { [long]$ep.maxSizeBytes } else { 0 }
                    $epParts    = $ep.name -split '/'
                    $epServer   = if ($epParts.Count -ge 2) { $epParts[0] } else { '' }
                    $epPoolName = if ($epParts.Count -ge 2) { $epParts[1] } else { $ep.name }

                    $epDbCount = 0
                    if ($sqlDBs) {
                        $epDbCount = @($sqlDBs | Where-Object { $_.elasticPoolId -and $_.elasticPoolId -match [regex]::Escape($epPoolName) }).Count
                    }

                    $null = $subResults.SqlElasticPools.Add([PSCustomObject]@{
                        Subscription        = $subName
                        ResourceGroup       = $ep.resourceGroup
                        Server              = $epServer
                        ElasticPoolName     = $epPoolName
                        Edition             = $ep.edition
                        SKU                 = $ep.skuName
                        Tier                = $ep.skuTier
                        Capacity            = $ep.skuCapacity
                        MaxSizeGiB          = [math]::Round($epMaxBytes / 1073741824, 0)
                        MaxSizeGB           = [math]::Round($epMaxBytes / 1e9, 3)
                        Region              = $ep.location
                        State               = $ep.state
                        DatabaseCount       = $epDbCount
                        PerDbMinCapacity    = $ep.perDbMinCapacity
                        PerDbMaxCapacity    = $ep.perDbMaxCapacity
                        ZoneRedundant       = $ep.zoneRedundant
                        LicenseType         = $ep.licenseType
                        Allocated_Bytes     = $epAllocBytes
                        Used_Bytes          = $epUsedBytes
                        Allocated_GB        = if ($epAllocBytes) { [math]::Round($epAllocBytes / 1e9, 3) } else { $null }
                        Used_GB             = if ($epUsedBytes)  { [math]::Round($epUsedBytes  / 1e9, 3) } else { $null }
                        StoragePercent      = $epStoragePct
                        DTU_Used            = $epDtuUsed
                        CPU_Percent         = $epCpuPct
                    })
                }
                Write-Host "  [$subName] SQL Elastic Pools: $($sqlEPs.Count)" -ForegroundColor Green
            }
        } catch {
            Write-Warning "  [$subName] SQL Elastic Pool discovery failed: $($_.Exception.Message)"
        }

        # MySQL Servers (Improvement #7: backup_storage_used metric)
        try {
            $mysqlServers = Local:Invoke-ARGSafe -Query $argQueries.MySqlFlexible -SubId $subId -ResourceTypeName 'MySQLServers' -MaxAttempts $maxRetries
            $mysqlSingleServers = Local:Invoke-ARGSafe -Query $argQueries.MySqlSingle -SubId $subId -ResourceTypeName 'MySQLSingleServers' -MaxAttempts $maxRetries

            $allMySqlServers = @()
            if ($mysqlServers) { $allMySqlServers += $mysqlServers }
            if ($mysqlSingleServers) { $allMySqlServers += $mysqlSingleServers }

            if ($allMySqlServers.Count -gt 0) {
                $mysqlMetricMap = $null
                if (-not $skipMetrics -and $mysqlServers -and $mysqlServers.Count -gt 0) {
                    $mysqlMetricMap = Local:Invoke-MetricBatch -Resources $mysqlServers `
                        -MetricNamespace 'microsoft.dbformysql/flexibleservers' `
                        -MetricNames @('storage_used','storage_percent','backup_storage_used') -AggType 'Maximum'
                }
                $mysqlSingleMetricMap = @{}
                if (-not $skipMetrics -and $mysqlSingleServers) {
                    foreach ($singleSrv in $mysqlSingleServers) {
                        $fb = Local:Get-MultiMetricSafe -ResourceId $singleSrv.id -MetricNames @('storage_used','storage_percent','backup_storage_used')
                        $mysqlSingleMetricMap[$singleSrv.id.ToLower()] = $fb
                    }
                }

                foreach ($mysql in $allMySqlServers) {
                    $isSingle = ($mysql.id -match 'microsoft\.dbformysql/servers$' -or ($mysqlSingleServers -and $mysql -in $mysqlSingleServers))
                    $serverType = if ($isSingle) { 'Single' } else { 'Flexible' }
                    $storageUsed = $null; $storagePct = $null; $backupStorageUsed = $null
                    $key = $mysql.id.ToLower()

                    if ($isSingle -and $mysqlSingleMetricMap.ContainsKey($key)) {
                        $storageUsed      = $mysqlSingleMetricMap[$key]['storage_used']
                        $storagePct       = $mysqlSingleMetricMap[$key]['storage_percent']
                        $backupStorageUsed = $mysqlSingleMetricMap[$key]['backup_storage_used']
                    } elseif (-not $isSingle -and $mysqlMetricMap -and $mysqlMetricMap.ContainsKey($key)) {
                        $storageUsed      = $mysqlMetricMap[$key]['storage_used']
                        $storagePct       = $mysqlMetricMap[$key]['storage_percent']
                        $backupStorageUsed = $mysqlMetricMap[$key]['backup_storage_used']
                    } elseif (-not $skipMetrics) {
                        $fb = Local:Get-MultiMetricSafe -ResourceId $mysql.id -MetricNames @('storage_used','storage_percent','backup_storage_used')
                        $storageUsed = $fb['storage_used']; $storagePct = $fb['storage_percent']; $backupStorageUsed = $fb['backup_storage_used']
                    }

                    $usedBytes = if ($storageUsed) { [double]$storageUsed } else { $null }
                    $bkBytes   = if ($backupStorageUsed) { [double]$backupStorageUsed } else { $null }
                    $storageMB = $null; $storageGB = $null
                    if ($isSingle) {
                        $storageMB = $mysql.storageMB
                        $storageGB = if ($storageMB) { [math]::Round($storageMB / 1024, 2) } else { $null }
                    } else {
                        $storageGB = $mysql.storageSizeGB
                        $storageMB = if ($storageGB) { $storageGB * 1024 } else { $null }
                    }

                    $null = $subResults.MySQLServers.Add([PSCustomObject]@{
                        Id                       = $mysql.id
                        Subscription             = $subName
                        ResourceGroupName        = $mysql.resourceGroup
                        Name                     = $mysql.name
                        ServerType               = $serverType
                        Location                 = $mysql.location
                        Region                   = $mysql.location
                        Version                  = $mysql.version
                        FullyQualifiedDomainName = $mysql.fqdn
                        BackupRetentionDays      = $mysql.backupRetention
                        StorageSku               = if ($isSingle) { $mysql.skuTier } else { $null }
                        SkuName                  = $mysql.skuName
                        StorageMB                = $storageMB
                        StorageGB                = $storageGB
                        StorageUsedBytes         = $usedBytes
                        StorageUsedMB            = if ($usedBytes) { [math]::Round($usedBytes / 1MB, 2) } else { $null }
                        StorageUsedGB            = if ($usedBytes) { [math]::Round($usedBytes / 1GB, 4) } else { $null }
                        StoragePercent           = $storagePct
                        BackupStorageUsedBytes   = $bkBytes
                        BackupStorageUsedGB      = if ($bkBytes) { [math]::Round($bkBytes / 1e9, 3) } else { $null }
                    })
                }
                Write-Host "  [$subName] MySQL Servers: $($allMySqlServers.Count)" -ForegroundColor Green
            }
        } catch {
            Write-Warning "  [$subName] MySQL discovery failed: $($_.Exception.Message)"
        }

        # PostgreSQL Servers (Improvement #7: backup_storage_used metric)
        try {
            $pgServers = Local:Invoke-ARGSafe -Query $argQueries.PostgreSqlFlexible -SubId $subId -ResourceTypeName 'PostgreSQLServers' -MaxAttempts $maxRetries
            $pgSingleServers = Local:Invoke-ARGSafe -Query $argQueries.PostgreSqlSingle -SubId $subId -ResourceTypeName 'PostgreSQLSingleServers' -MaxAttempts $maxRetries

            $allPgServers = @()
            if ($pgServers) { $allPgServers += $pgServers }
            if ($pgSingleServers) { $allPgServers += $pgSingleServers }

            if ($allPgServers.Count -gt 0) {
                $pgMetricMap = $null
                if (-not $skipMetrics -and $pgServers -and $pgServers.Count -gt 0) {
                    $pgMetricMap = Local:Invoke-MetricBatch -Resources $pgServers `
                        -MetricNamespace 'microsoft.dbforpostgresql/flexibleservers' `
                        -MetricNames @('storage_used','storage_percent','backup_storage_used') -AggType 'Maximum'
                }
                $pgSingleMetricMap = @{}
                if (-not $skipMetrics -and $pgSingleServers) {
                    foreach ($singleSrv in $pgSingleServers) {
                        $fb = Local:Get-MultiMetricSafe -ResourceId $singleSrv.id -MetricNames @('storage_used','storage_percent','backup_storage_used')
                        $pgSingleMetricMap[$singleSrv.id.ToLower()] = $fb
                    }
                }

                foreach ($pg in $allPgServers) {
                    $isSingle = ($pg.id -match 'microsoft\.dbforpostgresql/servers$' -or ($pgSingleServers -and $pg -in $pgSingleServers))
                    $serverType = if ($isSingle) { 'Single' } else { 'Flexible' }
                    $storageUsed = $null; $storagePct = $null; $backupStorageUsed = $null
                    $key = $pg.id.ToLower()

                    if ($isSingle -and $pgSingleMetricMap.ContainsKey($key)) {
                        $storageUsed      = $pgSingleMetricMap[$key]['storage_used']
                        $storagePct       = $pgSingleMetricMap[$key]['storage_percent']
                        $backupStorageUsed = $pgSingleMetricMap[$key]['backup_storage_used']
                    } elseif (-not $isSingle -and $pgMetricMap -and $pgMetricMap.ContainsKey($key)) {
                        $storageUsed      = $pgMetricMap[$key]['storage_used']
                        $storagePct       = $pgMetricMap[$key]['storage_percent']
                        $backupStorageUsed = $pgMetricMap[$key]['backup_storage_used']
                    } elseif (-not $skipMetrics) {
                        $fb = Local:Get-MultiMetricSafe -ResourceId $pg.id -MetricNames @('storage_used','storage_percent','backup_storage_used')
                        $storageUsed = $fb['storage_used']; $storagePct = $fb['storage_percent']; $backupStorageUsed = $fb['backup_storage_used']
                    }

                    $usedBytes = if ($storageUsed) { [double]$storageUsed } else { $null }
                    $bkBytes   = if ($backupStorageUsed) { [double]$backupStorageUsed } else { $null }
                    $storageMB = $null; $storageGB = $null
                    if ($isSingle) {
                        $storageMB = $pg.storageMB
                        $storageGB = if ($storageMB) { [math]::Round($storageMB / 1024, 2) } else { $null }
                    } else {
                        $storageGB = $pg.storageSizeGB
                        $storageMB = if ($storageGB) { $storageGB * 1024 } else { $null }
                    }

                    $null = $subResults.PostgreSQLServers.Add([PSCustomObject]@{
                        Subscription              = $subName
                        ResourceGroupName         = $pg.resourceGroup
                        Name                      = $pg.name
                        Id                        = $pg.id
                        ServerType                = $serverType
                        Location                  = $pg.location
                        Region                    = $pg.location
                        Version                   = $pg.version
                        FullyQualifiedDomainName  = $pg.fqdn
                        BackupRetentionDays       = $pg.backupRetention
                        SkuName                   = $pg.skuName
                        StorageMB                 = $storageMB
                        StorageGB                 = $storageGB
                        StorageUsedGB             = if ($usedBytes) { [math]::Round($usedBytes / 1e9, 4) } else { $null }
                        StoragePercent            = $storagePct
                        BackupStorageUsedBytes    = $bkBytes
                        BackupStorageUsedGB       = if ($bkBytes) { [math]::Round($bkBytes / 1e9, 3) } else { $null }
                    })
                }
                Write-Host "  [$subName] PostgreSQL Servers: $($allPgServers.Count)" -ForegroundColor Green
            }
        } catch {
            Write-Warning "  [$subName] PostgreSQL discovery failed: $($_.Exception.Message)"
        }
    }

    # ================================================================
    # CosmosDB
    # ================================================================
    if ($selectedRef.COSMOS) {
        Write-Host "  [$subName] Discovering CosmosDB via ARG..." -ForegroundColor DarkCyan
        try {
            $cosmosAccounts = Local:Invoke-ARGSafe -Query $argQueries.CosmosDB -SubId $subId -ResourceTypeName 'CosmosDB' -MaxAttempts $maxRetries
            if ($cosmosAccounts) {
                $cosmosMetricMap = $null
                if (-not $skipMetrics) {
                    $cosmosMetricMap = Local:Invoke-MetricBatch -Resources $cosmosAccounts `
                        -MetricNamespace 'microsoft.documentdb/databaseaccounts' `
                        -MetricNames @('DocumentCount','DataUsage','IndexUsage','PhysicalPartitionSizeInfo','PhysicalPartitionCount') -AggType 'Maximum'
                }

                foreach ($cosmos in $cosmosAccounts) {
                    $docCount = $null; $dataUsage = $null; $indexUsage = $null; $partSize = $null; $partCount = $null
                    $key = $cosmos.id.ToLower()
                    if ($cosmosMetricMap -and $cosmosMetricMap.ContainsKey($key)) {
                        $docCount   = $cosmosMetricMap[$key]['DocumentCount']
                        $dataUsage  = $cosmosMetricMap[$key]['DataUsage']
                        $indexUsage = $cosmosMetricMap[$key]['IndexUsage']
                        $partSize   = $cosmosMetricMap[$key]['PhysicalPartitionSizeInfo']
                        $partCount  = $cosmosMetricMap[$key]['PhysicalPartitionCount']
                    } elseif (-not $skipMetrics) {
                        $fb = Local:Get-MultiMetricSafe -ResourceId $cosmos.id `
                            -MetricNames @('DocumentCount','DataUsage','IndexUsage','PhysicalPartitionSizeInfo','PhysicalPartitionCount')
                        $docCount = $fb['DocumentCount']; $dataUsage = $fb['DataUsage']; $indexUsage = $fb['IndexUsage']
                        $partSize = $fb['PhysicalPartitionSizeInfo']; $partCount = $fb['PhysicalPartitionCount']
                    }

                    $dataUsageVal = if ($dataUsage) { [double]$dataUsage } else { $null }
                    $null = $subResults.CosmosDBAccounts.Add([PSCustomObject]@{
                        Subscription          = $subName
                        ResourceGroupName     = $cosmos.resourceGroup
                        Name                  = $cosmos.name
                        Location              = $cosmos.location
                        Id                    = $cosmos.id
                        Kind                  = $cosmos.cosmosKind
                        InstanceId            = $cosmos.instanceId
                        BackupPolicyBackupType = $cosmos.backupType
                        BackupPolicyBackupIntervalInMinutes      = $cosmos.backupInterval
                        BackupPolicyBackupRetentionIntervalInHours = $cosmos.backupRetention
                        BackupPolicyBackupStorageRedundancy       = $cosmos.backupRedundancy
                        MinimalTlsVersion     = $cosmos.minimalTlsVersion
                        DocumentCount         = $docCount
                        DataUsage             = $dataUsageVal
                        DataUsageGB           = if ($dataUsageVal) { [math]::Round($dataUsageVal / 1e9, 4) } else { $null }
                        PhysicalPartitionSizeInfo = $partSize
                        PhysicalPartitionCount    = $partCount
                        IndexUsage            = $indexUsage
                    })
                }
                Write-Host "  [$subName] CosmosDB Accounts: $($cosmosAccounts.Count)" -ForegroundColor Green
            }
        } catch {
            Write-Warning "  [$subName] CosmosDB discovery failed: $($_.Exception.Message)"
        }
    }

    # ================================================================
    # AKS Clusters
    # ================================================================
    if ($selectedRef.AKS) {
        Write-Host "  [$subName] Discovering AKS clusters via ARG..." -ForegroundColor DarkCyan
        try {
            $aksClusters = Local:Invoke-ARGSafe -Query $argQueries.AKS -SubId $subId -ResourceTypeName 'AKSClusters' -MaxAttempts $maxRetries
            if ($aksClusters) {
                $hasKubectl = $false
                try { $null = Get-Command kubectl -ErrorAction Stop; $hasKubectl = $true } catch {}

                foreach ($cluster in $aksClusters) {
                    $pvCount = $null; $pvcCount = $null; $pvCapGB = $null; $accessErr = $null

                    if ($hasKubectl) {
                        try {
                            Import-AzAksCredential -ResourceGroupName $cluster.resourceGroup `
                                -Name $cluster.name -SubscriptionId $subId -Force -ErrorAction Stop
                            $testResult = kubectl get nodes --request-timeout=10s 2>&1
                            if ($LASTEXITCODE -ne 0) {
                                $accessErr = "kubectl access failed: $testResult"
                            } else {
                                # PVs
                                $pvJson = kubectl get pv -o json --request-timeout=30s 2>&1
                                if ($LASTEXITCODE -eq 0 -and $pvJson) {
                                    $pvData = $pvJson | ConvertFrom-Json
                                    $pvCount = ($pvData.items | Measure-Object).Count
                                    $totalPVBytes = 0
                                    foreach ($pv in $pvData.items) {
                                        if ($pv.spec.capacity.storage) {
                                            $capBytes = 0
                                            $qty = $pv.spec.capacity.storage
                                            if ($qty -match '^(\d+\.?\d*)([KMGTPE]i?)?$') {
                                                $val = [double]$Matches[1]; $u = $Matches[2]
                                                $capBytes = switch ($u) {
                                                    'Ki' { $val * 1024 } 'Mi' { $val * 1048576 } 'Gi' { $val * 1073741824 }
                                                    'Ti' { $val * 1099511627776 } default { $val }
                                                }
                                            }
                                            $totalPVBytes += $capBytes
                                            $null = $subResults.AKSPVs.Add([PSCustomObject]@{
                                                ClusterName       = $cluster.name
                                                ResourceGroup     = $cluster.resourceGroup
                                                Subscription      = $subName
                                                PVName            = $pv.metadata.name
                                                StorageClass      = $pv.spec.storageClassName
                                                CapacityBytes     = $capBytes
                                                CapacityGB        = [math]::Round($capBytes / 1GB, 4)
                                                AccessModes       = ($pv.spec.accessModes -join ', ')
                                                ReclaimPolicy     = $pv.spec.persistentVolumeReclaimPolicy
                                                Status            = $pv.status.phase
                                                VolumeMode        = $pv.spec.volumeMode
                                                CreationTimestamp = $pv.metadata.creationTimestamp
                                                ClaimNamespace    = $pv.spec.claimRef.namespace
                                                ClaimName         = $pv.spec.claimRef.name
                                            })
                                        }
                                    }
                                    $pvCapGB = [math]::Round($totalPVBytes / 1GB, 2)
                                }
                                # PVCs
                                $pvcJson = kubectl get pvc -A -o json --request-timeout=30s 2>&1
                                if ($LASTEXITCODE -eq 0 -and $pvcJson) {
                                    $pvcData = $pvcJson | ConvertFrom-Json
                                    $pvcCount = ($pvcData.items | Measure-Object).Count
                                    foreach ($pvc in $pvcData.items) {
                                        $reqBytes = 0; $capBytes = 0
                                        if ($pvc.spec.resources.requests.storage) {
                                            $qty = $pvc.spec.resources.requests.storage
                                            if ($qty -match '^(\d+\.?\d*)([KMGTPE]i?)?$') {
                                                $val = [double]$Matches[1]; $u = $Matches[2]
                                                $reqBytes = switch ($u) {
                                                    'Ki' { $val * 1024 } 'Mi' { $val * 1048576 } 'Gi' { $val * 1073741824 }
                                                    'Ti' { $val * 1099511627776 } default { $val }
                                                }
                                            }
                                        }
                                        if ($pvc.status.capacity.storage) {
                                            $qty = $pvc.status.capacity.storage
                                            if ($qty -match '^(\d+\.?\d*)([KMGTPE]i?)?$') {
                                                $val = [double]$Matches[1]; $u = $Matches[2]
                                                $capBytes = switch ($u) {
                                                    'Ki' { $val * 1024 } 'Mi' { $val * 1048576 } 'Gi' { $val * 1073741824 }
                                                    'Ti' { $val * 1099511627776 } default { $val }
                                                }
                                            }
                                        }
                                        $null = $subResults.AKSPVCs.Add([PSCustomObject]@{
                                            ClusterName    = $cluster.name
                                            ResourceGroup  = $cluster.resourceGroup
                                            Subscription   = $subName
                                            Namespace      = $pvc.metadata.namespace
                                            PVCName        = $pvc.metadata.name
                                            StorageClass   = $pvc.spec.storageClassName
                                            RequestedBytes = $reqBytes
                                            RequestedGB    = [math]::Round($reqBytes / 1GB, 4)
                                            CapacityBytes  = $capBytes
                                            CapacityGB     = [math]::Round($capBytes / 1GB, 4)
                                            AccessModes    = ($pvc.spec.accessModes -join ', ')
                                            Status         = $pvc.status.phase
                                            VolumeMode     = $pvc.spec.volumeMode
                                            CreationTimestamp = $pvc.metadata.creationTimestamp
                                            VolumeName     = $pvc.spec.volumeName
                                        })
                                    }
                                }
                            }
                        } catch { $accessErr = $_.Exception.Message }
                    } else { $accessErr = "kubectl not available" }

                    $null = $subResults.AKSClusters.Add([PSCustomObject]@{
                        ClusterName                 = $cluster.name
                        Region                      = $cluster.location
                        Subscription                = $subName
                        ResourceGroup               = $cluster.resourceGroup
                        KubernetesVersion           = $cluster.kubernetesVersion
                        PersistentVolumeCount       = $pvCount
                        PersistentVolumeClaimCount  = $pvcCount
                        PersistentVolumeCapacityGB  = $pvCapGB
                        PersistentVolumeAccessError = $accessErr
                    })
                }
                Write-Host "  [$subName] AKS Clusters: $($aksClusters.Count)" -ForegroundColor Green
            }
        } catch {
            Write-Warning "  [$subName] AKS discovery failed: $($_.Exception.Message)"
        }
    }


    # ================================================================
    # Recovery Services Vaults
    # Improvement #1: Per-item backup size via REST extendedInfo
    # Improvement #2: Recovery point inventory per protected item
    # ================================================================
    if ($selectedRef.RSV) {
        Write-Host "  [$subName] Discovering Recovery Services Vaults via ARG..." -ForegroundColor DarkCyan
        try {
            $rsvVaults = Local:Invoke-ARGSafe -Query $argQueries.RSVVaults -SubId $subId -ResourceTypeName 'RSVVaults' -MaxAttempts $maxRetries
            $rsvItems = Local:Invoke-ARGSafe -Query $argQueries.RSVProtectedItems -SubId $subId -ResourceTypeName 'RSVProtectedItems' -MaxAttempts $maxRetries

            $vaultItemCounts = @{}
            $token = Local:Get-BearerToken

            if ($rsvItems) {
                foreach ($item in $rsvItems) {
                    $vn = $item.vaultName
                    if (-not $vaultItemCounts.ContainsKey($vn)) { $vaultItemCounts[$vn] = 0 }
                    $vaultItemCounts[$vn]++

                    # Improvement #1: Per-item backup size via REST with $expand=extendedInfo
                    $dsSize = $null; $diskSize = $null
                    if ($token) {
                        try {
                            $itemUri = "https://management.azure.com$($item.id)?api-version=2024-10-01&`$expand=extendedInfo"
                            $itemDetail = Local:Invoke-AzRestSafe -Uri $itemUri -Token $token -Retries 2
                            if ($itemDetail -and $itemDetail.properties -and $itemDetail.properties.extendedInfo) {
                                $ext = $itemDetail.properties.extendedInfo
                                if ($ext.protectedItemDataSourceSizeInBytes) {
                                    $dsSize = [double]$ext.protectedItemDataSourceSizeInBytes
                                }
                                if ($ext.protectedItemDiskDataSizeInBytes) {
                                    $diskSize = [double]$ext.protectedItemDiskDataSizeInBytes
                                }
                            }
                        } catch { }
                    }

                    $null = $subResults.RSVProtectedItems.Add([PSCustomObject]@{
                        Subscription         = $subName
                        VaultName            = $item.vaultName
                        FriendlyName         = $item.friendlyName
                        BackupManagementType = $item.backupManagementType
                        WorkloadType         = $item.workloadType
                        ProtectionState      = $item.protectionState
                        LastBackupStatus     = $item.lastBackupStatus
                        LastBackupTime       = $item.lastBackupTime
                        SourceResourceId     = $item.sourceResourceId
                        ProtectedItemType    = $item.protectedItemType
                        DataSourceSizeBytes  = $dsSize
                        DataSourceSizeGB     = if ($dsSize) { [math]::Round($dsSize / 1e9, 3) } else { $null }
                        DiskDataSizeBytes    = $diskSize
                        DiskDataSizeGB       = if ($diskSize) { [math]::Round($diskSize / 1e9, 3) } else { $null }
                    })

                    # Improvement #2: Recovery point inventory
                    if ($token) {
                        try {
                            $rpUri = "https://management.azure.com$($item.id)/recoveryPoints?api-version=2024-10-01&`$top=100"
                            $rpResp = Local:Invoke-AzRestSafe -Uri $rpUri -Token $token -Retries 2
                            if ($rpResp -and $rpResp.value) {
                                foreach ($rp in $rpResp.value) {
                                    $null = $subResults.RSVRecoveryPoints.Add([PSCustomObject]@{
                                        Subscription          = $subName
                                        VaultName             = $item.vaultName
                                        ProtectedItemName     = $item.friendlyName
                                        RecoveryPointId       = $rp.name
                                        RecoveryPointTime     = $rp.properties.recoveryPointTime
                                        RecoveryPointType     = $rp.properties.recoveryPointType
                                        RecoveryPointTier     = if ($rp.properties.recoveryPointTierDetails) { ($rp.properties.recoveryPointTierDetails | ForEach-Object { $_.type }) -join ',' } else { '' }
                                        SourceVMStorageType   = $rp.properties.sourceVMStorageType
                                        IsInstantILR          = $rp.properties.isInstantIlrSessionActive
                                    })
                                }
                            }
                        } catch { }
                    }
                }
                Write-Host "  [$subName] RSV Protected Items: $($rsvItems.Count) (with per-item sizes)" -ForegroundColor Green
                if ($subResults.RSVRecoveryPoints.Count -gt 0) {
                    Write-Host "  [$subName] RSV Recovery Points: $($subResults.RSVRecoveryPoints.Count)" -ForegroundColor Green
                }
            }

            if ($rsvVaults) {
                foreach ($vault in $rsvVaults) {
                    $backupStorageGB = 0; $storageBreakdown = ''
                    if ($token) {
                        try {
                            $usagesUri = "https://management.azure.com$($vault.id)/usages?api-version=2024-10-01"
                            $usagesResp = Local:Invoke-AzRestSafe -Uri $usagesUri -Token $token
                            if ($usagesResp -and $usagesResp.value) {
                                $storageParts = @()
                                foreach ($usage in $usagesResp.value) {
                                    $uName = $usage.name.value; $uBytes = $usage.currentValue
                                    if ($uName -match 'StorageUsage' -and $uBytes -gt 0) {
                                        $uGB = [math]::Round($uBytes / 1e9, 2)
                                        $backupStorageGB += $uGB
                                        $tier = $uName -replace 'StorageUsage',''
                                        $storageParts += "$tier`: $uGB GB"
                                    }
                                }
                                $storageBreakdown = $storageParts -join ' | '
                            }
                        } catch {
                            $errText = ($_.Exception.Message -replace '\r?\n',' ')
                            if ($errText.Length -gt 100) { $errText = $errText.Substring(0,100) + '...' }
                            $storageBreakdown = "UsagesAPI: $errText"
                        }
                    }
                    $itemCount = if ($vaultItemCounts.ContainsKey($vault.name)) { $vaultItemCounts[$vault.name] } else { 0 }

                    $null = $subResults.RSVVaults.Add([PSCustomObject]@{
                        Subscription        = $subName
                        VaultName           = $vault.name
                        ResourceGroup       = $vault.resourceGroup
                        Region              = $vault.location
                        SKU                 = $vault.skuName
                        StorageRedundancy   = $vault.storageRedundancy
                        CrossRegionRestore  = $vault.crossRegionRestore
                        ProtectedItemCount  = $itemCount
                        BackupStorageUsedGB = $backupStorageGB
                        BackupStorageUsedTB = [math]::Round($backupStorageGB / 1000, 4)
                        StorageDetail       = $storageBreakdown
                    })
                }
                Write-Host "  [$subName] RSV Vaults: $($rsvVaults.Count)" -ForegroundColor Green
            }

            # RSV Backup Policies
            $rsvPolicies = Local:Invoke-ARGSafe -Query $argQueries.RSVBackupPolicies -SubId $subId -ResourceTypeName 'RSVBackupPolicies' -MaxAttempts $maxRetries
            if ($rsvPolicies) {
                foreach ($pol in $rsvPolicies) {
                    $dailyRetention  = if ($pol.retentionDailyCount)  { "$($pol.retentionDailyCount) $($pol.retentionDailyType)" } else { '' }
                    $weeklyRetention = if ($pol.retentionWeeklyCount) { "$($pol.retentionWeeklyCount) $($pol.retentionWeeklyType)" } else { '' }
                    $monthlyRetention = if ($pol.retentionMonthlyCount) { "$($pol.retentionMonthlyCount) $($pol.retentionMonthlyType)" } else { '' }
                    $yearlyRetention = if ($pol.retentionYearlyCount) { "$($pol.retentionYearlyCount) $($pol.retentionYearlyType)" } else { '' }

                    $null = $subResults.RSVBackupPolicies.Add([PSCustomObject]@{
                        Subscription         = $subName
                        VaultName            = $pol.vaultName
                        PolicyName           = $pol.name
                        BackupManagementType = $pol.backupManagementType
                        PolicyType           = $pol.policyType
                        ProtectedItemsCount  = $pol.protectedItemsCount
                        ScheduleFrequency    = $pol.scheduleRunFrequency
                        ScheduleRunTimes     = $pol.scheduleRunTimes
                        DailyRetention       = $dailyRetention
                        WeeklyRetention      = $weeklyRetention
                        MonthlyRetention     = $monthlyRetention
                        YearlyRetention      = $yearlyRetention
                        InstantRpDays        = $pol.instantRpDays
                        TimeZone             = $pol.timeZone
                    })
                }
                Write-Host "  [$subName] RSV Backup Policies: $($rsvPolicies.Count)" -ForegroundColor Green
            }
        } catch {
            Write-Warning "  [$subName] RSV discovery failed: $($_.Exception.Message)"
        }
    }

    # ================================================================
    # Backup Vaults
    # Improvement #3: Better storage consumption via backup jobs
    # Improvement #4: Backup Vault Policies (rule-based schema)
    # ================================================================
    if ($selectedRef.BACKUP) {
        Write-Host "  [$subName] Discovering Backup Vaults via ARG..." -ForegroundColor DarkCyan
        try {
            $bkVaults = Local:Invoke-ARGSafe -Query $argQueries.BackupVaults -SubId $subId -ResourceTypeName 'BackupVaults' -MaxAttempts $maxRetries

            if ($bkVaults) {
                $token = Local:Get-BearerToken
                foreach ($vault in $bkVaults) {
                    $bkStorageGB = 0; $bkStorageBreakdown = ''
                    if ($token) {
                        try {
                            $bkUsagesUri = "https://management.azure.com$($vault.id)/usages?api-version=2023-01-01"
                            $bkUsagesResp = Local:Invoke-AzRestSafe -Uri $bkUsagesUri -Token $token
                            if ($bkUsagesResp -and $bkUsagesResp.value) {
                                $bkParts = @()
                                foreach ($usage in $bkUsagesResp.value) {
                                    $uName = $usage.name.value; $uBytes = $usage.currentValue
                                    if ($uBytes -and $uBytes -gt 0) {
                                        $uGB = [math]::Round($uBytes / 1e9, 2)
                                        $bkStorageGB += $uGB
                                        $bkParts += "$uName`: $uGB GB"
                                    }
                                }
                                $bkStorageBreakdown = $bkParts -join ' | '
                            }
                        } catch {
                            $errText = ($_.Exception.Message -replace '\r?\n',' ')
                            if ($errText.Length -gt 100) { $errText = $errText.Substring(0,100) + '...' }
                            $bkStorageBreakdown = "UsagesAPI: $errText"
                        }
                    }

                    $null = $subResults.BackupVaults.Add([PSCustomObject]@{
                        Subscription        = $subName
                        VaultName           = $vault.name
                        ResourceGroup       = $vault.resourceGroup
                        Region              = $vault.location
                        StorageType         = $vault.storageType
                        DatastoreType       = $vault.datastoreType
                        BackupStorageUsedGB = $bkStorageGB
                        BackupStorageUsedTB = [math]::Round($bkStorageGB / 1000, 4)
                        StorageDetail       = $bkStorageBreakdown
                    })

                    # Improvement #4: Backup Vault Policies via REST
                    if ($token) {
                        try {
                            $polUri = "https://management.azure.com$($vault.id)/backupPolicies?api-version=2023-01-01"
                            $polResp = Local:Invoke-AzRestSafe -Uri $polUri -Token $token
                            if ($polResp -and $polResp.value) {
                                foreach ($pol in $polResp.value) {
                                    $retentionRules = @()
                                    if ($pol.properties.policyRules) {
                                        foreach ($rule in $pol.properties.policyRules) {
                                            if ($rule.lifecycles) {
                                                foreach ($lc in $rule.lifecycles) {
                                                    $dur = $lc.deleteAfter
                                                    if ($dur) {
                                                        $retentionRules += "$($rule.name):$($dur.duration)($($dur.objectType))"
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    $null = $subResults.BackupVaultPolicies.Add([PSCustomObject]@{
                                        Subscription      = $subName
                                        VaultName         = $vault.name
                                        PolicyName        = $pol.name
                                        DatasourceType    = if ($pol.properties.datasourceTypes) { $pol.properties.datasourceTypes -join ',' } else { '' }
                                        RetentionRules    = $retentionRules -join ' | '
                                        ObjectType        = $pol.properties.objectType
                                    })
                                }
                            }
                        } catch { }
                    }
                }
                Write-Host "  [$subName] Backup Vaults: $($bkVaults.Count)" -ForegroundColor Green
                if ($subResults.BackupVaultPolicies.Count -gt 0) {
                    Write-Host "  [$subName] Backup Vault Policies: $($subResults.BackupVaultPolicies.Count)" -ForegroundColor Green
                }
            }

            # Backup Instances
            $bkInstances = Local:Invoke-ARGSafe -Query $argQueries.BackupInstances -SubId $subId -ResourceTypeName 'BackupInstances' -MaxAttempts $maxRetries
            if ($bkInstances) {
                foreach ($inst in $bkInstances) {
                    $null = $subResults.BackupInstances.Add([PSCustomObject]@{
                        Subscription          = $subName
                        VaultName             = $inst.vaultName
                        FriendlyName          = $inst.friendlyName
                        DatasourceType        = $inst.datasourceType
                        ResourceName          = $inst.resourceName
                        ProtectionStatus      = $inst.protectionStatus
                        CurrentProtectionState = $inst.currentProtectionState
                        SourceResourceId      = $inst.resourceId
                    })
                }
                Write-Host "  [$subName] Backup Instances: $($bkInstances.Count)" -ForegroundColor Green
            }
        } catch {
            Write-Warning "  [$subName] Backup Vault discovery failed: $($_.Exception.Message)"
        }
    }

    # ================================================================
    # Disk Snapshots
    # ================================================================
    if ($selectedRef.SNAPSHOT) {
        Write-Host "  [$subName] Discovering Disk Snapshots via ARG..." -ForegroundColor DarkCyan
        try {
            $snapshots = Local:Invoke-ARGSafe -Query $argQueries.DiskSnapshots -SubId $subId -ResourceTypeName 'DiskSnapshots' -MaxAttempts $maxRetries
            if ($snapshots) {
                foreach ($snap in $snapshots) {
                    $snapSizeGB = if ($snap.diskSizeGB) { [int]$snap.diskSizeGB } else { 0 }
                    $null = $subResults.DiskSnapshots.Add([PSCustomObject]@{
                        Subscription        = $subName
                        SnapshotName        = $snap.name
                        ResourceGroup       = $snap.resourceGroup
                        Region              = $snap.location
                        DiskSizeGB          = $snapSizeGB
                        DiskSizeTB          = [math]::Round($snapSizeGB / 1000, 4)
                        DiskSizeTiB         = [math]::Round($snapSizeGB / 1024, 4)
                        TimeCreated         = $snap.timeCreated
                        SourceResourceId    = $snap.sourceResourceId
                        CreateOption        = $snap.sourceType
                        OSType              = $snap.osType
                        SKU                 = $snap.skuName
                        Tier                = $snap.skuTier
                        Incremental         = $snap.incremental
                        ProvisioningState   = $snap.provisioningState
                        NetworkAccessPolicy = $snap.networkAccessPolicy
                    })
                }
                Write-Host "  [$subName] Disk Snapshots: $($snapshots.Count)" -ForegroundColor Green
            }
        } catch {
            Write-Warning "  [$subName] Disk Snapshot discovery failed: $($_.Exception.Message)"
        }
    }

    # ================================================================
    # Improvement #8: VM Restore Point Collections
    # ================================================================
    if ($selectedRef.RSV -or $selectedRef.VM) {
        Write-Host "  [$subName] Discovering VM Restore Point Collections via ARG..." -ForegroundColor DarkCyan
        try {
            $rpCollections = Local:Invoke-ARGSafe -Query $argQueries.RestorePointCollections -SubId $subId -ResourceTypeName 'RestorePointCollections' -MaxAttempts $maxRetries
            if ($rpCollections) {
                $token = Local:Get-BearerToken
                foreach ($rpc in $rpCollections) {
                    $rpCount = if ($rpc.restorePointCount) { [int]$rpc.restorePointCount } else { 0 }
                    $totalDiskSizeGB = 0

                    # Get restore point details via REST for disk size info
                    if ($token -and $rpCount -gt 0) {
                        try {
                            $rpcUri = "https://management.azure.com$($rpc.id)/restorePoints?api-version=2024-03-01"
                            $rpcResp = Local:Invoke-AzRestSafe -Uri $rpcUri -Token $token -Retries 2
                            if ($rpcResp -and $rpcResp.value) {
                                $rpCount = $rpcResp.value.Count
                                foreach ($rp in $rpcResp.value) {
                                    if ($rp.properties.sourceMetadata.storageProfile.dataDisks) {
                                        foreach ($dd in $rp.properties.sourceMetadata.storageProfile.dataDisks) {
                                            if ($dd.diskSizeGB) { $totalDiskSizeGB += [int]$dd.diskSizeGB }
                                        }
                                    }
                                    if ($rp.properties.sourceMetadata.storageProfile.osDisk.diskSizeGB) {
                                        $totalDiskSizeGB += [int]$rp.properties.sourceMetadata.storageProfile.osDisk.diskSizeGB
                                    }
                                }
                            }
                        } catch { }
                    }

                    $null = $subResults.VMRestorePoints.Add([PSCustomObject]@{
                        Subscription        = $subName
                        CollectionName      = $rpc.name
                        ResourceGroup       = $rpc.resourceGroup
                        Region              = $rpc.location
                        SourceVMId          = $rpc.sourceVmId
                        RestorePointCount   = $rpCount
                        TotalDiskSizeGB     = $totalDiskSizeGB
                        ProvisioningState   = $rpc.provisioningState
                    })
                }
                Write-Host "  [$subName] VM Restore Point Collections: $($rpCollections.Count)" -ForegroundColor Green
            }
        } catch {
            Write-Warning "  [$subName] VM Restore Point Collections discovery failed: $($_.Exception.Message)"
        }
    }

    # ================================================================
    # ASR Replicated Items (Improvement #9: replica disk sizes)
    # ================================================================
    if ($selectedRef.ASR) {
        Write-Host "  [$subName] Discovering ASR Replicated Items via ARG..." -ForegroundColor DarkCyan
        try {
            $asrItems = Local:Invoke-ARGSafe -Query $argQueries.ASRReplicatedItems -SubId $subId -ResourceTypeName 'ASRReplicatedItems' -MaxAttempts $maxRetries
            if ($asrItems) {
                $token = Local:Get-BearerToken
                foreach ($asr in $asrItems) {
                    $replicaDiskSizeGB = 0
                    $replicaDiskCount  = 0

                    # Improvement #9: Get detailed disk info via REST
                    if ($token) {
                        try {
                            $asrUri = "https://management.azure.com$($asr.id)?api-version=2024-10-01"
                            $asrDetail = Local:Invoke-AzRestSafe -Uri $asrUri -Token $token -Retries 2
                            if ($asrDetail -and $asrDetail.properties.providerSpecificDetails) {
                                $psd = $asrDetail.properties.providerSpecificDetails
                                # A2A protection: protectedManagedDisks or a2AProtectedManagedDiskDetails
                                if ($psd.protectedManagedDisks) {
                                    foreach ($disk in $psd.protectedManagedDisks) {
                                        $replicaDiskCount++
                                        if ($disk.diskCapacityInBytes) {
                                            $replicaDiskSizeGB += [math]::Round([double]$disk.diskCapacityInBytes / 1e9, 2)
                                        }
                                    }
                                }
                                if ($psd.protectedDisks) {
                                    foreach ($disk in $psd.protectedDisks) {
                                        $replicaDiskCount++
                                        if ($disk.diskCapacityInBytes) {
                                            $replicaDiskSizeGB += [math]::Round([double]$disk.diskCapacityInBytes / 1e9, 2)
                                        }
                                    }
                                }
                            }
                        } catch { }
                    }

                    $null = $subResults.ASRReplicatedItems.Add([PSCustomObject]@{
                        Subscription                  = $subName
                        VaultName                     = $asr.vaultName
                        FriendlyName                  = $asr.friendlyName
                        ProtectionState               = $asr.protectionState
                        ProtectionStateDescription    = $asr.protectionStateDescription
                        ActiveLocation                = $asr.activeLocation
                        TestFailoverState             = $asr.testFailoverState
                        TestFailoverStateDescription  = $asr.testFailoverStateDescription
                        ReplicationHealth             = $asr.replicationHealth
                        FailoverHealth                = $asr.failoverHealth
                        PrimaryFabric                 = $asr.primaryFabricFriendlyName
                        PrimaryContainer              = $asr.primaryProtectionContainerFriendlyName
                        RecoveryFabric                = $asr.recoveryFabricFriendlyName
                        RecoveryContainer             = $asr.recoveryProtectionContainerFriendlyName
                        ProtectedItemType             = $asr.protectedItemType
                        SourceVmId                    = $asr.sourceVmId
                        TargetResourceGroup           = $asr.targetRegion
                        ReplicaDiskCount              = $replicaDiskCount
                        ReplicaDiskSizeGB             = [math]::Round($replicaDiskSizeGB, 2)
                    })
                }
                Write-Host "  [$subName] ASR Replicated Items: $($asrItems.Count) (with disk sizes)" -ForegroundColor Green
            }
        } catch {
            Write-Warning "  [$subName] ASR discovery failed: $($_.Exception.Message)"
        }
    }

    Write-Host "[DONE] $subName" -ForegroundColor Green
    return $subResults

    } catch {
        # TOP-LEVEL SAFETY NET
        Write-Warning "PARTIAL-FAIL [$subName]: Unhandled exception - $($_.Exception.Message)"
        if ($subResults) {
            $subResults.Status = 'PartialFail'
            $null = $subResults.Errors.Add("[FATAL] $($_.Exception.Message)")
            return $subResults
        }
        return @{
            SubscriptionName = $subName
            SubscriptionId   = $subId
            Status           = 'Failed'
            Error            = $_.Exception.Message
            Errors           = [System.Collections.ArrayList]@("[FATAL] $($_.Exception.Message)")
        }
    }
}


# ============================================================================
# SECTION 6: AGGREGATE PARALLEL RESULTS
# ============================================================================

Write-Host "`n=== Aggregating Results ===" -ForegroundColor Yellow

$VMs                = [System.Collections.ArrayList]::new()
$OrphanedDisks      = [System.Collections.ArrayList]::new()
$StorageAccounts    = [System.Collections.ArrayList]::new()
$FileShares         = [System.Collections.ArrayList]::new()
$NetAppVolumes      = [System.Collections.ArrayList]::new()
$SqlManagedInst     = [System.Collections.ArrayList]::new()
$SqlDatabases       = [System.Collections.ArrayList]::new()
$SqlElasticPools    = [System.Collections.ArrayList]::new()
$SqlBackupStorage   = [System.Collections.ArrayList]::new()
$MySQLServers       = [System.Collections.ArrayList]::new()
$PostgreSQLServers  = [System.Collections.ArrayList]::new()
$SqlMIDbInventory   = [System.Collections.ArrayList]::new()
$CosmosDBAccounts   = [System.Collections.ArrayList]::new()
$AKSClusters        = [System.Collections.ArrayList]::new()
$AKSPVs             = [System.Collections.ArrayList]::new()
$AKSPVCs            = [System.Collections.ArrayList]::new()
$RSVVaults          = [System.Collections.ArrayList]::new()
$RSVProtectedItems  = [System.Collections.ArrayList]::new()
$RSVRecoveryPoints  = [System.Collections.ArrayList]::new()
$RSVBackupPolicies  = [System.Collections.ArrayList]::new()
$BackupVaults       = [System.Collections.ArrayList]::new()
$BackupInstances    = [System.Collections.ArrayList]::new()
$BackupVaultPolicies = [System.Collections.ArrayList]::new()
$DiskSnapshots      = [System.Collections.ArrayList]::new()
$VMRestorePoints    = [System.Collections.ArrayList]::new()
$ASRReplicatedItems = [System.Collections.ArrayList]::new()

$skippedSubs = @()
$partialSubs = @()

foreach ($result in $parallelResults) {
    if (-not $result -or $result -isnot [hashtable]) { continue }

    if ($result.Status -eq 'ContextFailed' -or $result.Status -eq 'AccessDenied') {
        $skippedSubs += "$($result.SubscriptionName) ($($result.Status): $($result.Error))"
        continue
    }
    if ($result.Status -eq 'Failed') {
        $skippedSubs += "$($result.SubscriptionName) (FAILED: $($result.Error))"
        continue
    }

    if ($result.VMs.Count)               { $null = $VMs.AddRange($result.VMs) }
    if ($result.OrphanedDisks.Count)     { $null = $OrphanedDisks.AddRange($result.OrphanedDisks) }
    if ($result.StorageAccounts.Count)   { $null = $StorageAccounts.AddRange($result.StorageAccounts) }
    if ($result.FileShares.Count)        { $null = $FileShares.AddRange($result.FileShares) }
    if ($result.NetAppVolumes.Count)     { $null = $NetAppVolumes.AddRange($result.NetAppVolumes) }
    if ($result.SqlManagedInst.Count)    { $null = $SqlManagedInst.AddRange($result.SqlManagedInst) }
    if ($result.SqlDatabases.Count)      { $null = $SqlDatabases.AddRange($result.SqlDatabases) }
    if ($result.SqlElasticPools.Count)   { $null = $SqlElasticPools.AddRange($result.SqlElasticPools) }
    if ($result.SqlBackupStorage.Count)  { $null = $SqlBackupStorage.AddRange($result.SqlBackupStorage) }
    if ($result.MySQLServers.Count)      { $null = $MySQLServers.AddRange($result.MySQLServers) }
    if ($result.PostgreSQLServers.Count) { $null = $PostgreSQLServers.AddRange($result.PostgreSQLServers) }
    if ($result.SqlMIDbInventory.Count)  { $null = $SqlMIDbInventory.AddRange($result.SqlMIDbInventory) }
    if ($result.CosmosDBAccounts.Count)  { $null = $CosmosDBAccounts.AddRange($result.CosmosDBAccounts) }
    if ($result.AKSClusters.Count)       { $null = $AKSClusters.AddRange($result.AKSClusters) }
    if ($result.AKSPVs.Count)            { $null = $AKSPVs.AddRange($result.AKSPVs) }
    if ($result.AKSPVCs.Count)           { $null = $AKSPVCs.AddRange($result.AKSPVCs) }
    if ($result.RSVVaults.Count)         { $null = $RSVVaults.AddRange($result.RSVVaults) }
    if ($result.RSVProtectedItems.Count) { $null = $RSVProtectedItems.AddRange($result.RSVProtectedItems) }
    if ($result.RSVRecoveryPoints.Count) { $null = $RSVRecoveryPoints.AddRange($result.RSVRecoveryPoints) }
    if ($result.RSVBackupPolicies.Count) { $null = $RSVBackupPolicies.AddRange($result.RSVBackupPolicies) }
    if ($result.BackupVaults.Count)      { $null = $BackupVaults.AddRange($result.BackupVaults) }
    if ($result.BackupInstances.Count)   { $null = $BackupInstances.AddRange($result.BackupInstances) }
    if ($result.BackupVaultPolicies.Count) { $null = $BackupVaultPolicies.AddRange($result.BackupVaultPolicies) }
    if ($result.DiskSnapshots.Count)     { $null = $DiskSnapshots.AddRange($result.DiskSnapshots) }
    if ($result.VMRestorePoints.Count)   { $null = $VMRestorePoints.AddRange($result.VMRestorePoints) }
    if ($result.ASRReplicatedItems.Count) { $null = $ASRReplicatedItems.AddRange($result.ASRReplicatedItems) }

    if ($result.Errors -and $result.Errors.Count -gt 0) {
        $partialSubs += @{ Name = $result.SubscriptionName; Errors = $result.Errors }
    }
}

# ============================================================================
# SECTION 6.1: BACKUP PROTECTION CROSS-REFERENCE
# ============================================================================

Write-Host "`n=== Cross-referencing Backup Protection ===" -ForegroundColor Yellow

$rsvProtectionLookup = @{}
foreach ($item in $RSVProtectedItems) {
    if ($item.SourceResourceId) {
        $key = $item.SourceResourceId.ToLower()
        if (-not $rsvProtectionLookup.ContainsKey($key)) { $rsvProtectionLookup[$key] = @() }
        $rsvProtectionLookup[$key] += $item
    }
}

$bkProtectionLookup = @{}
foreach ($inst in $BackupInstances) {
    if ($inst.SourceResourceId) {
        $key = $inst.SourceResourceId.ToLower()
        if (-not $bkProtectionLookup.ContainsKey($key)) { $bkProtectionLookup[$key] = @() }
        $bkProtectionLookup[$key] += $inst
    }
}

$protectionSummary = @{ Protected = 0; Unprotected = 0 }

# Stamp VMs
foreach ($vm in $VMs) {
    $vmResourcePattern = "/subscriptions/*/resourceGroups/$($vm.ResourceGroup)/providers/Microsoft.Compute/virtualMachines/$($vm.VMName)"
    $matched = $false
    foreach ($rsvKey in $rsvProtectionLookup.Keys) {
        if ($rsvKey -like $vmResourcePattern.ToLower()) {
            $first = $rsvProtectionLookup[$rsvKey][0]
            $vm | Add-Member -NotePropertyName 'IsBackedUp'       -NotePropertyValue $true -Force
            $vm | Add-Member -NotePropertyName 'BackupType'       -NotePropertyValue "RSV ($($first.BackupManagementType))" -Force
            $vm | Add-Member -NotePropertyName 'BackupVaultName'  -NotePropertyValue $first.VaultName -Force
            $vm | Add-Member -NotePropertyName 'ProtectionState'  -NotePropertyValue $first.ProtectionState -Force
            $vm | Add-Member -NotePropertyName 'LastBackupStatus' -NotePropertyValue $first.LastBackupStatus -Force
            $vm | Add-Member -NotePropertyName 'LastBackupTime'   -NotePropertyValue $first.LastBackupTime -Force
            $matched = $true
            $protectionSummary.Protected++
            break
        }
    }
    if (-not $matched) {
        $vm | Add-Member -NotePropertyName 'IsBackedUp'       -NotePropertyValue $false -Force
        $vm | Add-Member -NotePropertyName 'BackupType'       -NotePropertyValue 'None' -Force
        $vm | Add-Member -NotePropertyName 'BackupVaultName'  -NotePropertyValue '' -Force
        $vm | Add-Member -NotePropertyName 'ProtectionState'  -NotePropertyValue '' -Force
        $vm | Add-Member -NotePropertyName 'LastBackupStatus' -NotePropertyValue '' -Force
        $vm | Add-Member -NotePropertyName 'LastBackupTime'   -NotePropertyValue '' -Force
        $protectionSummary.Unprotected++
    }
}

# Stamp Storage Accounts
foreach ($sa in $StorageAccounts) {
    $protections = @()
    if ($sa.BlobSoftDeleteEnabled -eq 'true')      { $protections += "BlobSoftDelete($($sa.BlobSoftDeleteDays)d)" }
    if ($sa.ContainerSoftDeleteEnabled -eq 'true')  { $protections += "ContainerSoftDelete($($sa.ContainerSoftDeleteDays)d)" }
    if ($sa.BlobVersioningEnabled -eq 'true')        { $protections += 'BlobVersioning' }

    $saPattern = "/providers/Microsoft.Storage/storageAccounts/$($sa.StorageAccount)"
    $saBackedUp = $false; $saBackupVault = ''; $saBackupType = ''
    foreach ($rsvKey in $rsvProtectionLookup.Keys) {
        if ($rsvKey -like "*$($saPattern.ToLower())*") {
            $first = $rsvProtectionLookup[$rsvKey][0]
            $saBackedUp = $true; $saBackupType = "RSV ($($first.BackupManagementType))"; $saBackupVault = $first.VaultName
            break
        }
    }
    if (-not $saBackedUp) {
        foreach ($bkKey in $bkProtectionLookup.Keys) {
            if ($bkKey -like "*$($saPattern.ToLower())*") {
                $first = $bkProtectionLookup[$bkKey][0]
                $saBackedUp = $true; $saBackupType = "BackupVault ($($first.DatasourceType))"; $saBackupVault = $first.VaultName
                break
            }
        }
    }
    if ($saBackedUp) { $protections += "Backup:$saBackupVault" }

    $sa | Add-Member -NotePropertyName 'IsBackedUp'            -NotePropertyValue $saBackedUp -Force
    $sa | Add-Member -NotePropertyName 'BackupType'            -NotePropertyValue $(if ($saBackedUp) { $saBackupType } else { 'None' }) -Force
    $sa | Add-Member -NotePropertyName 'BackupVaultName'       -NotePropertyValue $saBackupVault -Force
    $sa | Add-Member -NotePropertyName 'DataProtectionSummary' -NotePropertyValue $(if ($protections.Count) { $protections -join ' | ' } else { 'NONE - No backup or soft-delete' }) -Force
}

# Stamp SQL Databases
foreach ($db in $SqlDatabases) {
    $dbProtections = @()
    if ($db.PITR_Days)          { $dbProtections += "PITR($($db.PITR_Days)d)" }
    if ($db.LTRWeeklyRetention -and $db.LTRWeeklyRetention -ne 'PT0S')  { $dbProtections += "LTR-W:$($db.LTRWeeklyRetention)" }
    if ($db.LTRMonthlyRetention -and $db.LTRMonthlyRetention -ne 'PT0S') { $dbProtections += "LTR-M:$($db.LTRMonthlyRetention)" }
    $db | Add-Member -NotePropertyName 'BackupProtectionSummary' -NotePropertyValue $(if ($dbProtections.Count) { $dbProtections -join ' | ' } else { 'Built-in geo-redundant only' }) -Force
}

foreach ($mi in $SqlManagedInst) {
    $mi | Add-Member -NotePropertyName 'BackupProtectionSummary' -NotePropertyValue 'Built-in automated backups (PITR + LTR configurable)' -Force
}

Write-Host "  Backup cross-reference complete." -ForegroundColor Green
if ($VMs.Count -gt 0) {
    Write-Host "    VMs:  $($protectionSummary.Protected) backed up, $($protectionSummary.Unprotected) NOT backed up" -ForegroundColor $(if ($protectionSummary.Unprotected -gt 0) { 'Yellow' } else { 'Green' })
}

# ============================================================================
# SECTION 7: CONSOLE SUMMARY
# ============================================================================

Write-Host "`n=== Discovery Complete ===" -ForegroundColor Green

if ($Selected.VM)        { Write-Host "  VMs:                  $($VMs.Count)" -ForegroundColor Cyan }
if ($VMs.Count -gt 0)    { Write-Host "  Orphaned Disks:       $($OrphanedDisks.Count)" -ForegroundColor $(if ($OrphanedDisks.Count -gt 0) { 'Yellow' } else { 'Cyan' }) }
if ($Selected.STORAGE)   { Write-Host "  Storage Accounts:     $($StorageAccounts.Count)" -ForegroundColor Cyan }
if ($Selected.FILESHARE) { Write-Host "  File Shares:          $($FileShares.Count)" -ForegroundColor Cyan }
if ($Selected.NETAPP)    { Write-Host "  NetApp Volumes:       $($NetAppVolumes.Count)" -ForegroundColor Cyan }
if ($Selected.SQL) {
    Write-Host "  SQL Managed Instances: $($SqlManagedInst.Count)" -ForegroundColor Cyan
    Write-Host "  SQL Databases:        $($SqlDatabases.Count)" -ForegroundColor Cyan
    Write-Host "  SQL Elastic Pools:    $($SqlElasticPools.Count)" -ForegroundColor Cyan
    Write-Host "  SQL Backup Storage:   $($SqlBackupStorage.Count) servers with data" -ForegroundColor Cyan
    Write-Host "  MySQL Servers:        $($MySQLServers.Count)" -ForegroundColor Cyan
    Write-Host "  PostgreSQL Servers:   $($PostgreSQLServers.Count)" -ForegroundColor Cyan
}
if ($Selected.COSMOS)    { Write-Host "  CosmosDB Accounts:    $($CosmosDBAccounts.Count)" -ForegroundColor Cyan }
if ($Selected.AKS)       { Write-Host "  AKS Clusters:         $($AKSClusters.Count)" -ForegroundColor Cyan }
if ($Selected.RSV) {
    Write-Host "  RSV Vaults:           $($RSVVaults.Count)" -ForegroundColor Cyan
    Write-Host "  RSV Protected Items:  $($RSVProtectedItems.Count)" -ForegroundColor Cyan
    Write-Host "  RSV Recovery Points:  $($RSVRecoveryPoints.Count)" -ForegroundColor Cyan
    Write-Host "  RSV Backup Policies:  $($RSVBackupPolicies.Count)" -ForegroundColor Cyan
}
if ($Selected.BACKUP) {
    Write-Host "  Backup Vaults:        $($BackupVaults.Count)" -ForegroundColor Cyan
    Write-Host "  Backup Instances:     $($BackupInstances.Count)" -ForegroundColor Cyan
    Write-Host "  Backup Vault Policies: $($BackupVaultPolicies.Count)" -ForegroundColor Cyan
}
if ($Selected.SNAPSHOT)  { Write-Host "  Disk Snapshots:       $($DiskSnapshots.Count)" -ForegroundColor Cyan }
if ($VMRestorePoints.Count -gt 0) { Write-Host "  VM Restore Points:    $($VMRestorePoints.Count)" -ForegroundColor Cyan }
if ($Selected.ASR)       { Write-Host "  ASR Replicated Items: $($ASRReplicatedItems.Count)" -ForegroundColor Cyan }

if ($skippedSubs.Count -gt 0) {
    Write-Host "`n  Skipped subscriptions:" -ForegroundColor Red
    $skippedSubs | ForEach-Object { Write-Host "    $_" -ForegroundColor DarkYellow }
}
if ($partialSubs.Count -gt 0) {
    Write-Host "`n  Partial failures:" -ForegroundColor Yellow
    foreach ($ps in $partialSubs) {
        Write-Host "    $($ps.Name):" -ForegroundColor Yellow
        foreach ($err in $ps.Errors) { Write-Host "      $err" -ForegroundColor DarkYellow }
    }
}


# ============================================================================
# SECTION 8: CSV EXPORT
# ============================================================================

Write-Host "`n=== Generating Output Files ===" -ForegroundColor Yellow

# Error report
$allErrors = [System.Collections.ArrayList]::new()
foreach ($s in $skippedSubs) {
    $null = $allErrors.Add([PSCustomObject]@{ Subscription = $s; Status = 'Skipped'; ResourceType = 'ALL'; ErrorDetail = 'Subscription fully inaccessible' })
}
foreach ($ps in $partialSubs) {
    foreach ($err in $ps.Errors) {
        $null = $allErrors.Add([PSCustomObject]@{ Subscription = $ps.Name; Status = 'PartialFailure'; ResourceType = ($err -replace '^\[.*?\]\s*(\w+).*','$1'); ErrorDetail = $err })
    }
}
if ($allErrors.Count -gt 0) {
    $allErrors | Export-Csv (Join-Path $outDir "azure_sizing_errors_$dateStr.csv") -NoTypeInformation
    Write-Host "  azure_sizing_errors_$dateStr.csv (access/error report)" -ForegroundColor Yellow
}

# Standard CSV exports
$csvExports = @(
    @{ Cond = { $Selected.VM -and $VMs.Count };             Data = { $VMs };              File = "azure_vm_info_$dateStr.csv" }
    @{ Cond = { $OrphanedDisks.Count -gt 0 };               Data = { $OrphanedDisks };    File = "azure_orphaned_disks_$dateStr.csv" }
    @{ Cond = { $Selected.STORAGE -and $StorageAccounts.Count }; Data = { $StorageAccounts }; File = "azure_storage_accounts_info_$dateStr.csv" }
    @{ Cond = { $Selected.FILESHARE -and $FileShares.Count }; Data = { $FileShares };     File = "azure_file_shares_info_$dateStr.csv" }
    @{ Cond = { $Selected.NETAPP -and $NetAppVolumes.Count }; Data = { $NetAppVolumes };   File = "azure_netapp_volumes_info_$dateStr.csv" }
    @{ Cond = { $Selected.SQL -and $SqlManagedInst.Count };  Data = { $SqlManagedInst };   File = "azure_sql_managed_instances_$dateStr.csv" }
    @{ Cond = { $Selected.SQL -and $SqlMIDbInventory.Count }; Data = { $SqlMIDbInventory }; File = "azure_sql_mi_databases_$dateStr.csv" }
    @{ Cond = { $Selected.SQL -and $SqlDatabases.Count };    Data = { $SqlDatabases };     File = "azure_sql_databases_inventory_$dateStr.csv" }
    @{ Cond = { $Selected.SQL -and $SqlElasticPools.Count }; Data = { $SqlElasticPools };  File = "azure_sql_elastic_pools_$dateStr.csv" }
    @{ Cond = { $Selected.SQL -and $SqlBackupStorage.Count }; Data = { $SqlBackupStorage }; File = "azure_sql_backup_storage_$dateStr.csv" }
    @{ Cond = { $Selected.SQL -and $MySQLServers.Count };    Data = { $MySQLServers };     File = "azure_mysql_servers_$dateStr.csv" }
    @{ Cond = { $Selected.SQL -and $PostgreSQLServers.Count }; Data = { $PostgreSQLServers }; File = "azure_postgresql_servers_$dateStr.csv" }
    @{ Cond = { $Selected.COSMOS -and $CosmosDBAccounts.Count }; Data = { $CosmosDBAccounts }; File = "azure_cosmosdb_accounts_$dateStr.csv" }
    @{ Cond = { $Selected.AKS -and $AKSClusters.Count };    Data = { $AKSClusters };      File = "azure_aks_clusters_$dateStr.csv" }
    @{ Cond = { $Selected.AKS -and $AKSPVs.Count };         Data = { $AKSPVs };           File = "azure_aks_persistent_volumes_$dateStr.csv" }
    @{ Cond = { $Selected.AKS -and $AKSPVCs.Count };        Data = { $AKSPVCs };          File = "azure_aks_persistent_volume_claims_$dateStr.csv" }
    @{ Cond = { $Selected.RSV -and $RSVVaults.Count };       Data = { $RSVVaults };        File = "azure_rsv_vaults_$dateStr.csv" }
    @{ Cond = { $Selected.RSV -and $RSVProtectedItems.Count }; Data = { $RSVProtectedItems }; File = "azure_rsv_protected_items_$dateStr.csv" }
    @{ Cond = { $RSVRecoveryPoints.Count -gt 0 };           Data = { $RSVRecoveryPoints }; File = "azure_rsv_recovery_points_$dateStr.csv" }
    @{ Cond = { $Selected.RSV -and $RSVBackupPolicies.Count }; Data = { $RSVBackupPolicies }; File = "azure_rsv_backup_policies_$dateStr.csv" }
    @{ Cond = { $Selected.BACKUP -and $BackupVaults.Count }; Data = { $BackupVaults };    File = "azure_backup_vaults_$dateStr.csv" }
    @{ Cond = { $Selected.BACKUP -and $BackupInstances.Count }; Data = { $BackupInstances }; File = "azure_backup_instances_$dateStr.csv" }
    @{ Cond = { $BackupVaultPolicies.Count -gt 0 };         Data = { $BackupVaultPolicies }; File = "azure_backup_vault_policies_$dateStr.csv" }
    @{ Cond = { $Selected.SNAPSHOT -and $DiskSnapshots.Count }; Data = { $DiskSnapshots }; File = "azure_disk_snapshots_$dateStr.csv" }
    @{ Cond = { $VMRestorePoints.Count -gt 0 };             Data = { $VMRestorePoints };   File = "azure_vm_restore_points_$dateStr.csv" }
    @{ Cond = { $Selected.ASR -and $ASRReplicatedItems.Count }; Data = { $ASRReplicatedItems }; File = "azure_asr_replicated_items_$dateStr.csv" }
)

foreach ($export in $csvExports) {
    if (& $export.Cond) {
        (& $export.Data) | Export-Csv (Join-Path $outDir $export.File) -NoTypeInformation
        Write-Host "  $($export.File)" -ForegroundColor Cyan
    }
}

# ============================================================================
# SECTION 9: UNIFIED SUMMARY CSV (same format as original for vendor export)
# Improvement #17: Shows BOTH MaxSize/Allocated AND Utilized for SQL so you
# can see the full picture — provisioned ceiling vs actual consumption.
# Elastic pool member DBs are noted but NOT excluded from DB-level totals;
# the pool row gives you the pool-level view alongside the DB-level view.
# ============================================================================

$summaryRows = [System.Collections.ArrayList]::new()

function Add-SummaryRow {
    param($Sub, $Type, $Region, $Count, $SizeGB, $SizeTB, $SizeTiB)
    $null = $script:summaryRows.Add([PSCustomObject]@{
        Subscription = $Sub
        ResourceType = $Type
        Region       = $Region
        Count        = $Count
        TotalSizeGB  = $SizeGB
        TotalSizeTB  = $SizeTB
        TotalSizeTiB = $SizeTiB
    })
}

# --- Global Totals ---
if ($Selected.VM -and $VMs.Count) {
    $totalGB = ($VMs | Measure-Object -Property VMDiskSizeGB -Sum).Sum
    if (-not $totalGB) { $totalGB = 0 }
    Add-SummaryRow 'All' 'VM' 'All' $VMs.Count $totalGB ([math]::Round($totalGB/1000,4)) ([math]::Round($totalGB/1024,4))
}
if ($OrphanedDisks.Count -gt 0) {
    $orphanGB = ($OrphanedDisks | Measure-Object -Property DiskSizeGB -Sum).Sum
    if (-not $orphanGB) { $orphanGB = 0 }
    Add-SummaryRow 'All' 'Orphaned Disks (waste - not counted in grand total)' 'All' $OrphanedDisks.Count $orphanGB ([math]::Round($orphanGB/1000,4)) ([math]::Round($orphanGB/1024,4))
}
if ($Selected.STORAGE -and $StorageAccounts.Count) {
    $totalGB = ($StorageAccounts | Measure-Object -Property UsedCapacityGB -Sum).Sum
    if (-not $totalGB) { $totalGB = 0 }
    $totalBlobs = 0
    $StorageAccounts | ForEach-Object { if ($_.BlobCount) { $totalBlobs += [long]$_.BlobCount } }
    Add-SummaryRow 'All' "Storage Account (Total Blobs: $totalBlobs)" 'All' $StorageAccounts.Count ([math]::Round($totalGB,2)) ([math]::Round($totalGB/1000,4)) ([math]::Round($totalGB/1024,4))
}
if ($Selected.FILESHARE -and $FileShares.Count) {
    $totalGB = ($FileShares | Measure-Object -Property UsedCapacityGB -Sum).Sum
    if (-not $totalGB) { $totalGB = 0 }
    Add-SummaryRow 'All' 'File Share' 'All' $FileShares.Count ([math]::Round($totalGB,2)) ([math]::Round($totalGB/1000,4)) ([math]::Round($totalGB/1024,4))
}
if ($Selected.NETAPP -and $NetAppVolumes.Count) {
    $totalGB = ($NetAppVolumes | Measure-Object -Property UsedCapacityGB -Sum).Sum
    if (-not $totalGB) { $totalGB = 0 }
    Add-SummaryRow 'All' 'NetApp Files Volume' 'All' $NetAppVolumes.Count ([math]::Round($totalGB,2)) ([math]::Round($totalGB/1000,4)) ([math]::Round($totalGB/1024,4))
}
if ($Selected.SQL -and $SqlManagedInst.Count) {
    $totalGB = ($SqlManagedInst | Measure-Object -Property StorageUsedGB -Sum).Sum
    if (-not $totalGB) { $totalGB = 0 }
    Add-SummaryRow 'All' 'SQL Managed Instances' 'All' $SqlManagedInst.Count ([math]::Round($totalGB,2)) ([math]::Round($totalGB/1000,4)) ([math]::Round($totalGB/1024,4))
}
if ($Selected.SQL -and $SqlDatabases.Count) {
    # Show ALL databases with MaxSizeGB (provisioned ceiling)
    $totalMaxGB = ($SqlDatabases | Measure-Object -Property MaxSizeGB -Sum).Sum
    if (-not $totalMaxGB) { $totalMaxGB = 0 }
    Add-SummaryRow 'All' 'SQL Databases (MaxSize/Provisioned)' 'All' $SqlDatabases.Count ([math]::Round($totalMaxGB,2)) ([math]::Round($totalMaxGB/1000,4)) ([math]::Round($totalMaxGB/1024,4))

    # Also show utilized for the full picture
    $totalUtilGB = 0
    $SqlDatabases | ForEach-Object { if ($_.Utilized_GB) { $totalUtilGB += [double]$_.Utilized_GB } }
    if ($totalUtilGB -gt 0) {
        Add-SummaryRow 'All' '  SQL Databases (Utilized/Actual)' 'All' $SqlDatabases.Count ([math]::Round($totalUtilGB,2)) ([math]::Round($totalUtilGB/1000,4)) ([math]::Round($totalUtilGB/1024,4))
    }

    # Informational: pool vs standalone breakdown
    $pooledCount = @($SqlDatabases | Where-Object { $_.ElasticPoolName }).Count
    $standaloneCount = $SqlDatabases.Count - $pooledCount
    if ($pooledCount -gt 0) {
        Add-SummaryRow 'All' "  SQL DBs (in Elastic Pools)" 'All' $pooledCount '' '' ''
        Add-SummaryRow 'All' "  SQL DBs (standalone)" 'All' $standaloneCount '' '' ''
    }
}
if ($Selected.SQL -and $SqlElasticPools.Count) {
    $totalGB = 0
    $SqlElasticPools | ForEach-Object { if ($_.Used_GB) { $totalGB += [double]$_.Used_GB } }
    Add-SummaryRow 'All' 'SQL Elastic Pools' 'All' $SqlElasticPools.Count ([math]::Round($totalGB,2)) ([math]::Round($totalGB/1000,4)) ([math]::Round($totalGB/1024,4))
}
if ($Selected.SQL -and $SqlBackupStorage.Count) {
    $totalGB = ($SqlBackupStorage | Measure-Object -Property BackupStorageGB -Sum).Sum
    if (-not $totalGB) { $totalGB = 0 }
    Add-SummaryRow 'All' 'SQL Automated Backup Storage' 'All' $SqlBackupStorage.Count ([math]::Round($totalGB,2)) ([math]::Round($totalGB/1000,4)) ([math]::Round($totalGB/1024,4))
}
if ($Selected.SQL -and $MySQLServers.Count) {
    $totalGB = 0
    $MySQLServers | ForEach-Object { if ($_.StorageUsedGB) { $totalGB += [double]$_.StorageUsedGB } }
    Add-SummaryRow 'All' 'MySQL Servers' 'All' $MySQLServers.Count ([math]::Round($totalGB,2)) ([math]::Round($totalGB/1000,4)) ([math]::Round($totalGB/1024,4))
}
if ($Selected.SQL -and $PostgreSQLServers.Count) {
    $totalGB = 0
    $PostgreSQLServers | ForEach-Object { if ($_.StorageUsedGB) { $totalGB += [double]$_.StorageUsedGB } }
    Add-SummaryRow 'All' 'PostgreSQL Servers' 'All' $PostgreSQLServers.Count ([math]::Round($totalGB,2)) ([math]::Round($totalGB/1000,4)) ([math]::Round($totalGB/1024,4))
}
if ($Selected.COSMOS -and $CosmosDBAccounts.Count) {
    $cosmosBytes = 0
    $CosmosDBAccounts | ForEach-Object { if ($_.DataUsage) { $cosmosBytes += [double]$_.DataUsage } }
    $cosmosGB = [math]::Round($cosmosBytes / 1e9, 2)
    Add-SummaryRow 'All' 'CosmosDB' 'All' $CosmosDBAccounts.Count $cosmosGB ([math]::Round($cosmosGB/1000,4)) ([math]::Round($cosmosBytes/1099511627776,4))
}
if ($Selected.AKS -and $AKSClusters.Count) {
    $totalPVGB = 0; $totalPVs = 0; $totalPVCs = 0
    $AKSClusters | ForEach-Object {
        if ($_.PersistentVolumeCapacityGB) { $totalPVGB += [double]$_.PersistentVolumeCapacityGB }
        if ($_.PersistentVolumeCount) { $totalPVs += [int]$_.PersistentVolumeCount }
        if ($_.PersistentVolumeClaimCount) { $totalPVCs += [int]$_.PersistentVolumeClaimCount }
    }
    Add-SummaryRow 'All' "AKS Clusters (Total PVs: $totalPVs, PVCs: $totalPVCs)" 'All' $AKSClusters.Count ([math]::Round($totalPVGB,2)) ([math]::Round($totalPVGB/1000,4)) ([math]::Round($totalPVGB/1024,4))
}
if ($Selected.RSV -and $RSVVaults.Count) {
    $totalRSVStorageGB = 0
    $RSVVaults | ForEach-Object { if ($_.BackupStorageUsedGB) { $totalRSVStorageGB += [double]$_.BackupStorageUsedGB } }
    $totalProtected = ($RSVProtectedItems | Measure-Object).Count
    Add-SummaryRow 'All' "Recovery Services Vaults (Protected Items: $totalProtected)" 'All' $RSVVaults.Count ([math]::Round($totalRSVStorageGB,2)) ([math]::Round($totalRSVStorageGB/1000,4)) ([math]::Round($totalRSVStorageGB/1024,4))
}
if ($Selected.BACKUP -and $BackupVaults.Count) {
    $totalBkStorageGB = 0
    $BackupVaults | ForEach-Object { if ($_.BackupStorageUsedGB) { $totalBkStorageGB += [double]$_.BackupStorageUsedGB } }
    Add-SummaryRow 'All' "Backup Vaults (Backup Instances: $($BackupInstances.Count))" 'All' $BackupVaults.Count ([math]::Round($totalBkStorageGB,2)) ([math]::Round($totalBkStorageGB/1000,4)) ([math]::Round($totalBkStorageGB/1024,4))
}
if ($Selected.SNAPSHOT -and $DiskSnapshots.Count) {
    $totalSnapGB = ($DiskSnapshots | Measure-Object -Property DiskSizeGB -Sum).Sum
    if (-not $totalSnapGB) { $totalSnapGB = 0 }
    Add-SummaryRow 'All' 'Disk Snapshots' 'All' $DiskSnapshots.Count ([math]::Round($totalSnapGB,2)) ([math]::Round($totalSnapGB/1000,4)) ([math]::Round($totalSnapGB/1024,4))
}
if ($VMRestorePoints.Count -gt 0) {
    $totalRpGB = ($VMRestorePoints | Measure-Object -Property TotalDiskSizeGB -Sum).Sum
    if (-not $totalRpGB) { $totalRpGB = 0 }
    Add-SummaryRow 'All' 'VM Restore Point Collections' 'All' $VMRestorePoints.Count ([math]::Round($totalRpGB,2)) ([math]::Round($totalRpGB/1000,4)) ([math]::Round($totalRpGB/1024,4))
}
if ($Selected.ASR -and $ASRReplicatedItems.Count) {
    $asrDiskGB = ($ASRReplicatedItems | Measure-Object -Property ReplicaDiskSizeGB -Sum).Sum
    if (-not $asrDiskGB) { $asrDiskGB = 0 }
    Add-SummaryRow 'All' 'ASR Replicated Items' 'All' $ASRReplicatedItems.Count ([math]::Round($asrDiskGB,2)) ([math]::Round($asrDiskGB/1000,4)) ([math]::Round($asrDiskGB/1024,4))
}

# Blank separator
Add-SummaryRow '' '' '' '' '' '' ''

# --- Per-Subscription Breakdown (restored from original) ---
Add-SummaryRow '[ Subscription level Summary ]' '' '' '' '' '' ''

foreach ($sub in $targetSubs) {
    $sn = $sub.Name
    Add-SummaryRow $sn '' '' '' '' '' ''

    if ($Selected.VM) {
        $subVMs = @($VMs | Where-Object { $_.Subscription -eq $sn })
        if ($subVMs.Count -gt 0) {
            $totalGB = ($subVMs | Measure-Object -Property VMDiskSizeGB -Sum).Sum
            if (-not $totalGB) { $totalGB = 0 }
            Add-SummaryRow $sn 'VM' 'All' $subVMs.Count $totalGB ([math]::Round($totalGB/1000,4)) ([math]::Round($totalGB/1024,4))
            $subVMs | Group-Object Region | ForEach-Object {
                $rGB = ($_.Group | Measure-Object -Property VMDiskSizeGB -Sum).Sum
                if (-not $rGB) { $rGB = 0 }
                Add-SummaryRow $sn 'VM' $_.Name $_.Count $rGB ([math]::Round($rGB/1000,4)) ([math]::Round($rGB/1024,4))
            }
        }
    }

    if ($Selected.STORAGE) {
        $subSA = @($StorageAccounts | Where-Object { $_.Subscription -eq $sn })
        if ($subSA.Count -gt 0) {
            $totalGB = ($subSA | Measure-Object -Property UsedCapacityGB -Sum).Sum
            if (-not $totalGB) { $totalGB = 0 }
            $subBlobs = 0
            $subSA | ForEach-Object { if ($_.BlobCount) { $subBlobs += [long]$_.BlobCount } }
            Add-SummaryRow $sn "Storage Account (Total Blobs: $subBlobs)" 'All' $subSA.Count ([math]::Round($totalGB,2)) ([math]::Round($totalGB/1000,4)) ([math]::Round($totalGB/1024,4))
        }
    }

    if ($Selected.FILESHARE) {
        $subFS = @($FileShares | Where-Object { $_.Subscription -eq $sn })
        if ($subFS.Count -gt 0) {
            $totalGB = ($subFS | Measure-Object -Property UsedCapacityGB -Sum).Sum
            if (-not $totalGB) { $totalGB = 0 }
            Add-SummaryRow $sn 'File Share' 'All' $subFS.Count ([math]::Round($totalGB,2)) ([math]::Round($totalGB/1000,4)) ([math]::Round($totalGB/1024,4))
        }
    }

    if ($Selected.NETAPP) {
        $subNAV = @($NetAppVolumes | Where-Object { $_.Subscription -eq $sn })
        if ($subNAV.Count -gt 0) {
            $totalGB = ($subNAV | Measure-Object -Property UsedCapacityGB -Sum).Sum
            if (-not $totalGB) { $totalGB = 0 }
            Add-SummaryRow $sn 'NetApp Files Volume' 'All' $subNAV.Count ([math]::Round($totalGB,2)) ([math]::Round($totalGB/1000,4)) ([math]::Round($totalGB/1024,4))
        }
    }

    if ($Selected.SQL) {
        $subMI = @($SqlManagedInst | Where-Object { $_.Subscription -eq $sn })
        if ($subMI.Count -gt 0) {
            $totalGB = ($subMI | Measure-Object -Property StorageUsedGB -Sum).Sum
            if (-not $totalGB) { $totalGB = 0 }
            Add-SummaryRow $sn 'SQL Managed Instances' 'All' $subMI.Count ([math]::Round($totalGB,2)) ([math]::Round($totalGB/1000,4)) ([math]::Round($totalGB/1024,4))
        }

        $subDB = @($SqlDatabases | Where-Object { $_.Subscription -eq $sn })
        if ($subDB.Count -gt 0) {
            $totalGB = ($subDB | Measure-Object -Property MaxSizeGB -Sum).Sum
            if (-not $totalGB) { $totalGB = 0 }
            Add-SummaryRow $sn 'SQL Databases' 'All' $subDB.Count ([math]::Round($totalGB,2)) ([math]::Round($totalGB/1000,4)) ([math]::Round($totalGB/1024,4))
        }

        $subEP = @($SqlElasticPools | Where-Object { $_.Subscription -eq $sn })
        if ($subEP.Count -gt 0) {
            $epGB = 0
            $subEP | ForEach-Object { if ($_.Used_GB) { $epGB += [double]$_.Used_GB } }
            Add-SummaryRow $sn 'SQL Elastic Pools' 'All' $subEP.Count ([math]::Round($epGB,2)) ([math]::Round($epGB/1000,4)) ([math]::Round($epGB/1024,4))
        }

        $subMySQL = @($MySQLServers | Where-Object { $_.Subscription -eq $sn })
        if ($subMySQL.Count -gt 0) {
            $totalGB = 0
            $subMySQL | ForEach-Object { if ($_.StorageUsedGB) { $totalGB += [double]$_.StorageUsedGB } }
            Add-SummaryRow $sn 'MySQL Servers' 'All' $subMySQL.Count ([math]::Round($totalGB,2)) ([math]::Round($totalGB/1000,4)) ([math]::Round($totalGB/1024,4))
        }

        $subPG = @($PostgreSQLServers | Where-Object { $_.Subscription -eq $sn })
        if ($subPG.Count -gt 0) {
            $totalGB = 0
            $subPG | ForEach-Object { if ($_.StorageUsedGB) { $totalGB += [double]$_.StorageUsedGB } }
            Add-SummaryRow $sn 'PostgreSQL Servers' 'All' $subPG.Count ([math]::Round($totalGB,2)) ([math]::Round($totalGB/1000,4)) ([math]::Round($totalGB/1024,4))
        }
    }

    if ($Selected.COSMOS) {
        $subCosmos = @($CosmosDBAccounts | Where-Object { $_.Subscription -eq $sn })
        if ($subCosmos.Count -gt 0) {
            $cosmosBytes = 0
            $subCosmos | ForEach-Object { if ($_.DataUsage) { $cosmosBytes += [double]$_.DataUsage } }
            $cosmosGB = [math]::Round($cosmosBytes / 1e9, 2)
            Add-SummaryRow $sn 'CosmosDB' 'All' $subCosmos.Count $cosmosGB ([math]::Round($cosmosGB/1000,4)) ([math]::Round($cosmosBytes/1099511627776,4))
        }
    }

    if ($Selected.AKS) {
        $subAKS = @($AKSClusters | Where-Object { $_.Subscription -eq $sn })
        if ($subAKS.Count -gt 0) {
            $pvGB = 0
            $subAKS | ForEach-Object { if ($_.PersistentVolumeCapacityGB) { $pvGB += [double]$_.PersistentVolumeCapacityGB } }
            Add-SummaryRow $sn 'AKS Clusters' 'All' $subAKS.Count ([math]::Round($pvGB,2)) ([math]::Round($pvGB/1000,4)) ([math]::Round($pvGB/1024,4))
        }
    }

    if ($Selected.RSV) {
        $subRSV = @($RSVVaults | Where-Object { $_.Subscription -eq $sn })
        if ($subRSV.Count -gt 0) {
            $rsvGB = 0
            $subRSV | ForEach-Object { if ($_.BackupStorageUsedGB) { $rsvGB += [double]$_.BackupStorageUsedGB } }
            Add-SummaryRow $sn 'Recovery Services Vaults' 'All' $subRSV.Count ([math]::Round($rsvGB,2)) ([math]::Round($rsvGB/1000,4)) ([math]::Round($rsvGB/1024,4))
        }
    }

    if ($Selected.BACKUP) {
        $subBK = @($BackupVaults | Where-Object { $_.Subscription -eq $sn })
        if ($subBK.Count -gt 0) {
            $bkGB = 0
            $subBK | ForEach-Object { if ($_.BackupStorageUsedGB) { $bkGB += [double]$_.BackupStorageUsedGB } }
            Add-SummaryRow $sn 'Backup Vaults' 'All' $subBK.Count ([math]::Round($bkGB,2)) ([math]::Round($bkGB/1000,4)) ([math]::Round($bkGB/1024,4))
        }
    }

    if ($Selected.SNAPSHOT) {
        $subSnap = @($DiskSnapshots | Where-Object { $_.Subscription -eq $sn })
        if ($subSnap.Count -gt 0) {
            $snapGB = ($subSnap | Measure-Object -Property DiskSizeGB -Sum).Sum
            if (-not $snapGB) { $snapGB = 0 }
            Add-SummaryRow $sn 'Disk Snapshots' 'All' $subSnap.Count ([math]::Round($snapGB,2)) ([math]::Round($snapGB/1000,4)) ([math]::Round($snapGB/1024,4))
        }
    }

    if ($Selected.ASR) {
        $subASR = @($ASRReplicatedItems | Where-Object { $_.Subscription -eq $sn })
        if ($subASR.Count -gt 0) {
            $asrGB = ($subASR | Measure-Object -Property ReplicaDiskSizeGB -Sum).Sum
            if (-not $asrGB) { $asrGB = 0 }
            Add-SummaryRow $sn 'ASR Replicated Items' 'All' $subASR.Count ([math]::Round($asrGB,2)) ([math]::Round($asrGB/1000,4)) ([math]::Round($asrGB/1024,4))
        }
    }

    Add-SummaryRow '' '' '' '' '' '' ''
}

# --- Grand Total ---
# Improvement #17: Two grand total rows — one using MaxSize/Provisioned,
# one using Utilized/Actual — so you can see the full picture and make
# informed decisions on scalability and support sizing.
Add-SummaryRow '' '' '' '' '' '' ''
Add-SummaryRow '[ GRAND TOTALS ]' '' '' '' '' '' ''

$grandTotalMaxGB  = 0.0
$grandTotalUsedGB = 0.0
$grandTotalCount  = 0

if ($Selected.VM -and $VMs.Count) {
    $t = ($VMs | Measure-Object -Property VMDiskSizeGB -Sum).Sum
    if ($t) { $grandTotalMaxGB += $t; $grandTotalUsedGB += $t; $grandTotalCount += $VMs.Count }
}
if ($Selected.STORAGE -and $StorageAccounts.Count) {
    $t = ($StorageAccounts | Measure-Object -Property UsedCapacityGB -Sum).Sum
    if ($t) { $grandTotalMaxGB += $t; $grandTotalUsedGB += $t; $grandTotalCount += $StorageAccounts.Count }
}
if ($Selected.FILESHARE -and $FileShares.Count) {
    $t = ($FileShares | Measure-Object -Property UsedCapacityGB -Sum).Sum
    if ($t) { $grandTotalMaxGB += $t; $grandTotalUsedGB += $t; $grandTotalCount += $FileShares.Count }
}
if ($Selected.NETAPP -and $NetAppVolumes.Count) {
    $t = ($NetAppVolumes | Measure-Object -Property UsedCapacityGB -Sum).Sum
    if ($t) { $grandTotalMaxGB += $t; $grandTotalUsedGB += $t; $grandTotalCount += $NetAppVolumes.Count }
}
if ($Selected.SQL -and $SqlManagedInst.Count) {
    $tUsed = ($SqlManagedInst | Measure-Object -Property StorageUsedGB -Sum).Sum; if (-not $tUsed) { $tUsed = 0 }
    $tMax  = ($SqlManagedInst | Measure-Object -Property StorageSizeGB -Sum).Sum; if (-not $tMax) { $tMax = 0 }
    $grandTotalUsedGB += $tUsed; $grandTotalMaxGB += $tMax
    $grandTotalCount += $SqlManagedInst.Count
}
if ($Selected.SQL -and $SqlDatabases.Count) {
    # All databases counted (pooled + standalone) — both metrics
    $tMax  = ($SqlDatabases | Measure-Object -Property MaxSizeGB -Sum).Sum; if (-not $tMax) { $tMax = 0 }
    $tUsed = 0; $SqlDatabases | ForEach-Object { if ($_.Utilized_GB) { $tUsed += [double]$_.Utilized_GB } }
    $grandTotalMaxGB  += $tMax
    $grandTotalUsedGB += $tUsed
    $grandTotalCount  += $SqlDatabases.Count
}
if ($Selected.SQL -and $SqlElasticPools.Count) {
    $tMax = 0; $tUsed = 0
    $SqlElasticPools | ForEach-Object {
        if ($_.MaxSizeGB) { $tMax += [double]$_.MaxSizeGB }
        if ($_.Used_GB)   { $tUsed += [double]$_.Used_GB }
    }
    $grandTotalMaxGB  += $tMax
    $grandTotalUsedGB += $tUsed
    $grandTotalCount  += $SqlElasticPools.Count
}
if ($Selected.SQL -and $MySQLServers.Count) {
    $MySQLServers | ForEach-Object {
        if ($_.StorageGB)     { $grandTotalMaxGB  += [double]$_.StorageGB }
        if ($_.StorageUsedGB) { $grandTotalUsedGB += [double]$_.StorageUsedGB }
    }
    $grandTotalCount += $MySQLServers.Count
}
if ($Selected.SQL -and $PostgreSQLServers.Count) {
    $PostgreSQLServers | ForEach-Object {
        if ($_.StorageGB)     { $grandTotalMaxGB  += [double]$_.StorageGB }
        if ($_.StorageUsedGB) { $grandTotalUsedGB += [double]$_.StorageUsedGB }
    }
    $grandTotalCount += $PostgreSQLServers.Count
}
if ($Selected.COSMOS -and $CosmosDBAccounts.Count) {
    $CosmosDBAccounts | ForEach-Object { if ($_.DataUsage) { $b = [double]$_.DataUsage / 1e9; $grandTotalMaxGB += $b; $grandTotalUsedGB += $b } }
    $grandTotalCount += $CosmosDBAccounts.Count
}
if ($Selected.AKS -and $AKSClusters.Count) {
    $AKSClusters | ForEach-Object { if ($_.PersistentVolumeCapacityGB) { $b = [double]$_.PersistentVolumeCapacityGB; $grandTotalMaxGB += $b; $grandTotalUsedGB += $b } }
    $grandTotalCount += $AKSClusters.Count
}
if ($Selected.RSV -and $RSVVaults.Count) {
    $RSVVaults | ForEach-Object { if ($_.BackupStorageUsedGB) { $b = [double]$_.BackupStorageUsedGB; $grandTotalMaxGB += $b; $grandTotalUsedGB += $b } }
    $grandTotalCount += $RSVVaults.Count
}
if ($Selected.BACKUP -and $BackupVaults.Count) {
    $BackupVaults | ForEach-Object { if ($_.BackupStorageUsedGB) { $b = [double]$_.BackupStorageUsedGB; $grandTotalMaxGB += $b; $grandTotalUsedGB += $b } }
    $grandTotalCount += $BackupVaults.Count
}
if ($Selected.SNAPSHOT -and $DiskSnapshots.Count) {
    $t = ($DiskSnapshots | Measure-Object -Property DiskSizeGB -Sum).Sum
    if ($t) { $grandTotalMaxGB += $t; $grandTotalUsedGB += $t; $grandTotalCount += $DiskSnapshots.Count }
}
if ($Selected.ASR -and $ASRReplicatedItems.Count) {
    $t = ($ASRReplicatedItems | Measure-Object -Property ReplicaDiskSizeGB -Sum).Sum
    if ($t) { $grandTotalMaxGB += $t; $grandTotalUsedGB += $t }
    $grandTotalCount += $ASRReplicatedItems.Count
}

Add-SummaryRow '[ GRAND TOTAL - Provisioned/MaxSize ]' 'All Resource Types' 'All' $grandTotalCount ([math]::Round($grandTotalMaxGB,2)) ([math]::Round($grandTotalMaxGB/1000,4)) ([math]::Round($grandTotalMaxGB/1024,4))
Add-SummaryRow '[ GRAND TOTAL - Utilized/Actual ]'     'All Resource Types' 'All' $grandTotalCount ([math]::Round($grandTotalUsedGB,2)) ([math]::Round($grandTotalUsedGB/1000,4)) ([math]::Round($grandTotalUsedGB/1024,4))

$summaryRows | Export-Csv (Join-Path $outDir "azure_inventory_summary_$dateStr.csv") -NoTypeInformation
Write-Host "  azure_inventory_summary_$dateStr.csv" -ForegroundColor Cyan


# ============================================================================
# SECTION 10: EXECUTIVE EXCEL REPORT (ImportExcel)
# ============================================================================

if (Get-Module -ListAvailable -Name ImportExcel) {
    Write-Host "`n=== Generating Executive Excel Report ===" -ForegroundColor Yellow
    $xlsxPath = Join-Path $outDir "azure_sizing_executive_$dateStr.xlsx"

    try {
        Import-Module ImportExcel -ErrorAction Stop
        $tabsCreated = 0

        function Add-ResourceTypeSheet {
            param(
                [string]$XlsxPath, [string]$RawSheetName, [string]$PivotSheetName,
                [string]$PivotTitle, [System.Collections.IList]$Data,
                [string[]]$PivotRows, [hashtable]$PivotData, [string]$ChartTitle
            )
            if (-not $Data -or $Data.Count -eq 0) { return }
            $Data | Export-Excel -Path $XlsxPath -WorksheetName $RawSheetName -AutoSize -AutoFilter -FreezeTopRow -BoldTopRow
            try {
                $pivotDef = New-PivotTableDefinition -PivotTableName $PivotTitle `
                    -SourceWorksheet $RawSheetName -PivotRows $PivotRows `
                    -PivotData $PivotData -ChartType BarClustered `
                    -ChartTitle $ChartTitle -ChartHeight 500 -ChartWidth 1000 -IncludePivotChart
                $Data | Export-Excel -Path $XlsxPath -WorksheetName $RawSheetName -AutoSize -PivotTableDefinition $pivotDef
            } catch {
                Write-Warning "  Pivot table for $RawSheetName skipped: $($_.Exception.Message)"
            }
            $script:tabsCreated++
            Write-Host "  Tab: $RawSheetName ($($Data.Count) rows)" -ForegroundColor DarkCyan
        }

        # VM Tab (includes power state, backup status)
        if ($Selected.VM -and $VMs.Count) {
            $vmExcel = $VMs | ForEach-Object {
                [PSCustomObject]@{
                    Subscription = $_.Subscription; ResourceGroup = $_.ResourceGroup; VMName = $_.VMName
                    VMSize = $_.VMSize; OS = $_.OS; Region = $_.Region; PowerState = $_.PowerState
                    DiskCount = $_.DiskCount; DiskSizeGB = $_.VMDiskSizeGB
                    DiskSizeTB = [math]::Round($_.VMDiskSizeGB / 1000, 4)
                    IsBackedUp = $_.IsBackedUp; BackupType = $_.BackupType; BackupVault = $_.BackupVaultName
                }
            }
            Add-ResourceTypeSheet -XlsxPath $xlsxPath -RawSheetName 'VM-RawData' -PivotSheetName 'VM-Pivot' `
                -PivotTitle 'VM_Summary' -Data $vmExcel -PivotRows @('Subscription','Region') `
                -PivotData @{DiskSizeGB='Sum'; VMName='Count'} -ChartTitle 'VM Disk Allocation by Subscription (GB)'
        }

        # Orphaned Disks Tab
        if ($OrphanedDisks.Count -gt 0) {
            Add-ResourceTypeSheet -XlsxPath $xlsxPath -RawSheetName 'OrphanedDisks' -PivotSheetName 'OrphanedDisks-Pivot' `
                -PivotTitle 'Orphaned_Summary' -Data $OrphanedDisks -PivotRows @('Subscription','Region') `
                -PivotData @{DiskSizeGB='Sum'; DiskName='Count'} -ChartTitle 'Orphaned Disk Waste by Subscription (GB)'
        }

        # Storage Tab (includes service breakdown)
        if ($Selected.STORAGE -and $StorageAccounts.Count) {
            $saExcel = $StorageAccounts | ForEach-Object {
                [PSCustomObject]@{
                    Subscription = $_.Subscription; StorageAccount = $_.StorageAccount; Kind = $_.StorageAccountType
                    SKU = $_.StorageAccountSkuName; Region = $_.Region; ResourceGroup = $_.ResourceGroup
                    UsedCapacityGB = $_.UsedCapacityGB; UsedCapacityTB = $_.UsedCapacityTB
                    UsedBlobCapacityGB = $_.UsedBlobCapacityGB; UsedFileCapacityGB = $_.UsedFileCapacityGB
                    UsedTableCapacityGB = $_.UsedTableCapacityGB; UsedQueueCapacityGB = $_.UsedQueueCapacityGB
                    BlobCount = $_.BlobCount; IsBackedUp = $_.IsBackedUp; DataProtection = $_.DataProtectionSummary
                }
            }
            Add-ResourceTypeSheet -XlsxPath $xlsxPath -RawSheetName 'Storage-RawData' -PivotSheetName 'Storage-Pivot' `
                -PivotTitle 'Storage_Summary' -Data $saExcel -PivotRows @('Subscription','Region') `
                -PivotData @{UsedCapacityGB='Sum'; StorageAccount='Count'} -ChartTitle 'Storage Used Capacity (GB)'
        }

        # File Share Tab (includes snapshot count - Improvement #10)
        if ($Selected.FILESHARE -and $FileShares.Count) {
            $fsExcel = $FileShares | ForEach-Object {
                [PSCustomObject]@{
                    Subscription   = $_.Subscription
                    FileShareName  = $_.Name
                    StorageAccount = $_.StorageAccount
                    ShareTier      = $_.ShareTier
                    Protocol       = $_.ProtocolType
                    Region         = $_.Region
                    QuotaGB        = $_.QuotaGB
                    QuotaTB        = $_.QuotaTB
                    QuotaGiB       = $_.QuotaGiB
                    QuotaTiB       = $_.QuotaTiB
                    UsedCapacityGB = $_.UsedCapacityGB
                    UsedCapacityTB = $_.UsedCapacityTB
                    UsedCapacityGiB = $_.UsedCapacityGiB
                    UsedCapacityTiB = $_.UsedCapacityTiB
                    SnapshotCount  = $_.SnapshotCount
                }
            }
            Add-ResourceTypeSheet -XlsxPath $xlsxPath -RawSheetName 'FileShare-RawData' -PivotSheetName 'FileShare-Pivot' `
                -PivotTitle 'FileShare_Summary' -Data $fsExcel -PivotRows @('Subscription','Region') `
                -PivotData @{UsedCapacityGB='Sum'; QuotaGB='Sum'; FileShareName='Count'} -ChartTitle 'File Share Capacity by Subscription (GB)'
        }

        # NetApp Tab
        if ($Selected.NETAPP -and $NetAppVolumes.Count) {
            $navExcel = $NetAppVolumes | ForEach-Object {
                [PSCustomObject]@{
                    Subscription   = $_.Subscription
                    VolumeName     = $_.VolumeName
                    NetAppAccount  = $_.NetAppAccount
                    CapacityPool   = $_.CapacityPool
                    ServiceLevel   = $_.ServiceLevel
                    Region         = $_.Region
                    ResourceGroup  = $_.ResourceGroup
                    ProvisionedGB  = $_.ProvisionedGB
                    ProvisionedTB  = $_.ProvisionedTB
                    ProvisionedGiB = $_.ProvisionedGiB
                    ProvisionedTiB = $_.ProvisionedTiB
                    UsedCapacityGB = $_.UsedCapacityGB
                    UsedCapacityTB = $_.UsedCapacityTB
                    UsedCapacityGiB = $_.UsedCapacityGiB
                    UsedCapacityTiB = $_.UsedCapacityTiB
                    PoolSizeGB     = $_.PoolSizeGB
                    PoolSizeTiB    = $_.PoolSizeTiB
                }
            }
            Add-ResourceTypeSheet -XlsxPath $xlsxPath -RawSheetName 'NetApp-RawData' -PivotSheetName 'NetApp-Pivot' `
                -PivotTitle 'NetApp_Summary' -Data $navExcel -PivotRows @('Subscription','Region') `
                -PivotData @{UsedCapacityGB='Sum'; ProvisionedGB='Sum'; VolumeName='Count'} -ChartTitle 'NetApp Volume Capacity by Subscription (GB)'
        }

        # SQL MI Tab
        if ($Selected.SQL -and $SqlManagedInst.Count) {
            $miExcel = $SqlManagedInst | ForEach-Object {
                [PSCustomObject]@{
                    Subscription      = $_.Subscription
                    InstanceName      = $_.ManagedInstanceName
                    Region            = $_.Region
                    ResourceGroup     = $_.ResourceGroup
                    vCores            = $_.vCores
                    AllocatedGB       = $_.StorageSizeGB
                    AllocatedTiB      = $_.StorageAllocatedTiB
                    UsedGB            = $_.StorageUsedGB
                    UsedTB            = $_.StorageUsedTB
                    UsedMB            = $_.StorageUsedMB
                    UsedTiB           = $_.StorageUsedTiB
                    LicenseType       = $_.LicenseType
                    State             = $_.State
                    BackupProtection  = $_.BackupProtectionSummary
                }
            }
            Add-ResourceTypeSheet -XlsxPath $xlsxPath -RawSheetName 'SQL-MI-RawData' -PivotSheetName 'SQL-MI-Pivot' `
                -PivotTitle 'SQL_MI_Summary' -Data $miExcel -PivotRows @('Subscription','Region') `
                -PivotData @{UsedGB='Sum'; AllocatedGB='Sum'; InstanceName='Count'} -ChartTitle 'SQL Managed Instance Storage by Subscription (GB)'
        }

        # SQL MI Database Inventory Tab
        if ($Selected.SQL -and $SqlMIDbInventory.Count) {
            $miDbExcel = $SqlMIDbInventory | ForEach-Object {
                [PSCustomObject]@{
                    Subscription       = $_.Subscription
                    ManagedInstance    = $_.ManagedInstanceName
                    DatabaseName       = $_.DatabaseName
                    Status             = $_.Status
                    CreationDate       = $_.CreationDate
                    Collation          = $_.Collation
                    Region             = $_.Region
                    LongTermRetention  = $_.LongTermRetentionPolicyJson
                    ShortTermRetention = $_.ShortTermRetentionPolicyJson
                }
            }
            Add-ResourceTypeSheet -XlsxPath $xlsxPath -RawSheetName 'SQL-MI-DB-RawData' -PivotSheetName 'SQL-MI-DB-Pivot' `
                -PivotTitle 'SQL_MI_DB_Summary' -Data $miDbExcel -PivotRows @('Subscription','ManagedInstance') `
                -PivotData @{DatabaseName='Count'} -ChartTitle 'SQL MI Databases by Instance'
        }

        # SQL DB Tab
        if ($Selected.SQL -and $SqlDatabases.Count) {
            $dbExcel = $SqlDatabases | ForEach-Object {
                [PSCustomObject]@{
                    Subscription       = $_.Subscription
                    Server             = $_.Server
                    Database           = $_.Database
                    Edition            = $_.Edition
                    SKU                = $_.InstanceType
                    ElasticPool        = $_.ElasticPoolName
                    Region             = $_.Region
                    ResourceGroup      = $_.ResourceGroup
                    MaxSizeGB          = $_.MaxSizeGB
                    MaxSizeGiB         = $_.MaxSizeGiB
                    AllocatedGB        = $_.Allocated_GB
                    UsedGB             = $_.Utilized_GB
                    PercentUsed        = $_.PercentUsed
                    LTRWeeklyRetention = $_.LTRWeeklyRetention
                    LTRMonthlyRetention = $_.LTRMonthlyRetention
                    PITR_Days          = $_.PITR_Days
                    BackupProtection   = $_.BackupProtectionSummary
                }
            }
            Add-ResourceTypeSheet -XlsxPath $xlsxPath -RawSheetName 'SQL-DB-RawData' -PivotSheetName 'SQL-DB-Pivot' `
                -PivotTitle 'SQL_DB_Summary' -Data $dbExcel -PivotRows @('Subscription','Region') `
                -PivotData @{UsedGB='Sum'; MaxSizeGB='Sum'; Database='Count'} -ChartTitle 'SQL Database Storage by Subscription (GB)'
        }

        # SQL Elastic Pools Tab
        if ($Selected.SQL -and $SqlElasticPools.Count) {
            $epExcel = $SqlElasticPools | ForEach-Object {
                [PSCustomObject]@{
                    Subscription     = $_.Subscription
                    Server           = $_.Server
                    ElasticPool      = $_.ElasticPoolName
                    Edition          = $_.Edition
                    SKU              = $_.SKU
                    Tier             = $_.Tier
                    Capacity         = $_.Capacity
                    Region           = $_.Region
                    ResourceGroup    = $_.ResourceGroup
                    DatabaseCount    = $_.DatabaseCount
                    MaxSizeGB        = $_.MaxSizeGB
                    AllocatedGB      = $_.Allocated_GB
                    UsedGB           = $_.Used_GB
                    StoragePercent   = $_.StoragePercent
                    DTU_Used         = $_.DTU_Used
                    CPU_Percent      = $_.CPU_Percent
                    PerDbMinCapacity = $_.PerDbMinCapacity
                    PerDbMaxCapacity = $_.PerDbMaxCapacity
                    LicenseType      = $_.LicenseType
                }
            }
            Add-ResourceTypeSheet -XlsxPath $xlsxPath -RawSheetName 'SQL-EP-RawData' -PivotSheetName 'SQL-EP-Pivot' `
                -PivotTitle 'SQL_EP_Summary' -Data $epExcel -PivotRows @('Subscription','Region') `
                -PivotData @{UsedGB='Sum'; MaxSizeGB='Sum'; DatabaseCount='Sum'; ElasticPool='Count'} -ChartTitle 'SQL Elastic Pool Storage by Subscription (GB)'
        }

        # SQL Backup Storage Tab (Improvement #5)
        if ($SqlBackupStorage.Count -gt 0) {
            Add-ResourceTypeSheet -XlsxPath $xlsxPath -RawSheetName 'SQL-BackupStorage' -PivotSheetName 'SQL-Backup-Pivot' `
                -PivotTitle 'SQL_Backup_Summary' -Data $SqlBackupStorage -PivotRows @('Subscription','Region') `
                -PivotData @{BackupStorageGB='Sum'; ServerName='Count'} -ChartTitle 'SQL Backup Storage by Subscription (GB)'
        }

        # MySQL Tab (Improvement #7: includes backup storage)
        if ($Selected.SQL -and $MySQLServers.Count) {
            $mysqlExcel = $MySQLServers | ForEach-Object {
                [PSCustomObject]@{
                    Subscription      = $_.Subscription
                    ServerName        = $_.Name
                    ServerType        = $_.ServerType
                    Version           = $_.Version
                    SKU               = $_.SkuName
                    StorageSku        = $_.StorageSku
                    Region            = $_.Region
                    AllocatedGB       = $_.StorageGB
                    UsedGB            = $_.StorageUsedGB
                    StoragePercent    = $_.StoragePercent
                    BackupStorageGB   = $_.BackupStorageUsedGB
                }
            }
            Add-ResourceTypeSheet -XlsxPath $xlsxPath -RawSheetName 'MySQL-RawData' -PivotSheetName 'MySQL-Pivot' `
                -PivotTitle 'MySQL_Summary' -Data $mysqlExcel -PivotRows @('Subscription','Region') `
                -PivotData @{UsedGB='Sum'; AllocatedGB='Sum'; ServerName='Count'} -ChartTitle 'MySQL Storage by Subscription (GB)'
        }

        # PostgreSQL Tab (Improvement #7: includes backup storage)
        if ($Selected.SQL -and $PostgreSQLServers.Count) {
            $pgExcel = $PostgreSQLServers | ForEach-Object {
                [PSCustomObject]@{
                    Subscription      = $_.Subscription
                    ServerName        = $_.Name
                    ServerType        = $_.ServerType
                    Version           = $_.Version
                    SKU               = $_.SkuName
                    Region            = $_.Region
                    AllocatedGB       = $_.StorageGB
                    UsedGB            = $_.StorageUsedGB
                    StoragePercent    = $_.StoragePercent
                    BackupStorageGB   = $_.BackupStorageUsedGB
                }
            }
            Add-ResourceTypeSheet -XlsxPath $xlsxPath -RawSheetName 'PostgreSQL-RawData' -PivotSheetName 'PostgreSQL-Pivot' `
                -PivotTitle 'PostgreSQL_Summary' -Data $pgExcel -PivotRows @('Subscription','Region') `
                -PivotData @{UsedGB='Sum'; AllocatedGB='Sum'; ServerName='Count'} -ChartTitle 'PostgreSQL Storage by Subscription (GB)'
        }

        # CosmosDB Tab
        if ($Selected.COSMOS -and $CosmosDBAccounts.Count) {
            $cosmosExcel = $CosmosDBAccounts | ForEach-Object {
                [PSCustomObject]@{
                    Subscription      = $_.Subscription
                    AccountName       = $_.Name
                    Kind              = $_.Kind
                    InstanceId        = $_.InstanceId
                    MinimalTlsVersion = $_.MinimalTlsVersion
                    Region            = $_.Location
                    ResourceGroup     = $_.ResourceGroupName
                    DataUsageGB       = $_.DataUsageGB
                    DocumentCount     = $_.DocumentCount
                    IndexUsage        = $_.IndexUsage
                    BackupType        = $_.BackupPolicyBackupType
                }
            }
            Add-ResourceTypeSheet -XlsxPath $xlsxPath -RawSheetName 'CosmosDB-RawData' -PivotSheetName 'CosmosDB-Pivot' `
                -PivotTitle 'CosmosDB_Summary' -Data $cosmosExcel -PivotRows @('Subscription','Region') `
                -PivotData @{DataUsageGB='Sum'; AccountName='Count'} -ChartTitle 'CosmosDB Data Usage by Subscription (GB)'
        }

        # AKS Tab
        if ($Selected.AKS -and $AKSClusters.Count) {
            $aksExcel = $AKSClusters | ForEach-Object {
                [PSCustomObject]@{
                    Subscription     = $_.Subscription
                    ClusterName      = $_.ClusterName
                    K8sVersion       = $_.KubernetesVersion
                    Region           = $_.Region
                    ResourceGroup    = $_.ResourceGroup
                    PVCount          = $_.PersistentVolumeCount
                    PVCCount         = $_.PersistentVolumeClaimCount
                    PVCapacityGB     = $_.PersistentVolumeCapacityGB
                    AccessError      = $_.PersistentVolumeAccessError
                }
            }
            Add-ResourceTypeSheet -XlsxPath $xlsxPath -RawSheetName 'AKS-RawData' -PivotSheetName 'AKS-Pivot' `
                -PivotTitle 'AKS_Summary' -Data $aksExcel -PivotRows @('Subscription','Region') `
                -PivotData @{PVCapacityGB='Sum'; ClusterName='Count'} -ChartTitle 'AKS PV Capacity by Subscription (GB)'
        }

        # RSV Vaults Tab
        if ($Selected.RSV -and $RSVVaults.Count) {
            $rsvExcel = $RSVVaults | ForEach-Object {
                [PSCustomObject]@{
                    Subscription        = $_.Subscription
                    VaultName           = $_.VaultName
                    ResourceGroup       = $_.ResourceGroup
                    Region              = $_.Region
                    StorageRedundancy   = $_.StorageRedundancy
                    ProtectedItemCount  = $_.ProtectedItemCount
                    BackupStorageUsedGB = $_.BackupStorageUsedGB
                    BackupStorageUsedTB = $_.BackupStorageUsedTB
                    StorageDetail       = $_.StorageDetail
                }
            }
            Add-ResourceTypeSheet -XlsxPath $xlsxPath -RawSheetName 'RSV-Vaults' -PivotSheetName 'RSV-Vault-Pivot' `
                -PivotTitle 'RSV_Vault_Summary' -Data $rsvExcel -PivotRows @('Subscription','Region') `
                -PivotData @{BackupStorageUsedGB='Sum'; ProtectedItemCount='Sum'; VaultName='Count'} -ChartTitle 'RSV Backup Storage by Subscription (GB)'
        }

        # RSV Protected Items Tab (Improvement #1: per-item sizes)
        if ($Selected.RSV -and $RSVProtectedItems.Count) {
            $rsvItemExcel = $RSVProtectedItems | ForEach-Object {
                [PSCustomObject]@{
                    Subscription         = $_.Subscription
                    VaultName            = $_.VaultName
                    ProtectedItem        = $_.FriendlyName
                    BackupMgmtType       = $_.BackupManagementType
                    WorkloadType         = $_.WorkloadType
                    ProtectionState      = $_.ProtectionState
                    LastBackupStatus     = $_.LastBackupStatus
                    LastBackupTime       = $_.LastBackupTime
                    DataSourceSizeGB     = $_.DataSourceSizeGB
                    DiskDataSizeGB       = $_.DiskDataSizeGB
                    SourceResourceId     = $_.SourceResourceId
                }
            }
            Add-ResourceTypeSheet -XlsxPath $xlsxPath -RawSheetName 'RSV-Items' -PivotSheetName 'RSV-Items-Pivot' `
                -PivotTitle 'RSV_Items_Summary' -Data $rsvItemExcel -PivotRows @('Subscription','BackupMgmtType') `
                -PivotData @{DataSourceSizeGB='Sum'; ProtectedItem='Count'} -ChartTitle 'RSV Protected Items by Subscription and Type'
        }

        # RSV Recovery Points Tab (Improvement #2)
        if ($RSVRecoveryPoints.Count -gt 0) {
            Add-ResourceTypeSheet -XlsxPath $xlsxPath -RawSheetName 'RSV-RecoveryPts' -PivotSheetName 'RSV-RP-Pivot' `
                -PivotTitle 'RSV_RP_Summary' -Data $RSVRecoveryPoints -PivotRows @('Subscription','VaultName') `
                -PivotData @{RecoveryPointId='Count'} -ChartTitle 'Recovery Points by Vault'
        }

        # RSV Backup Policies Tab
        if ($Selected.RSV -and $RSVBackupPolicies.Count) {
            $polExcel = $RSVBackupPolicies | ForEach-Object {
                [PSCustomObject]@{
                    Subscription         = $_.Subscription
                    VaultName            = $_.VaultName
                    PolicyName           = $_.PolicyName
                    BackupManagementType = $_.BackupManagementType
                    PolicyType           = $_.PolicyType
                    ProtectedItemsCount  = $_.ProtectedItemsCount
                    ScheduleFrequency    = $_.ScheduleFrequency
                    ScheduleRunTimes     = $_.ScheduleRunTimes
                    DailyRetention       = $_.DailyRetention
                    WeeklyRetention      = $_.WeeklyRetention
                    MonthlyRetention     = $_.MonthlyRetention
                    YearlyRetention      = $_.YearlyRetention
                    InstantRpDays        = $_.InstantRpDays
                    TimeZone             = $_.TimeZone
                }
            }
            Add-ResourceTypeSheet -XlsxPath $xlsxPath -RawSheetName 'RSV-Policies' -PivotSheetName 'RSV-Policy-Pivot' `
                -PivotTitle 'RSV_Policy_Summary' -Data $polExcel -PivotRows @('Subscription','BackupManagementType') `
                -PivotData @{PolicyName='Count'; ProtectedItemsCount='Sum'} -ChartTitle 'RSV Backup Policies by Type'
        }

        # Backup Vaults Tab
        if ($Selected.BACKUP -and $BackupVaults.Count) {
            $bkVaultExcel = $BackupVaults | ForEach-Object {
                [PSCustomObject]@{
                    Subscription        = $_.Subscription
                    VaultName           = $_.VaultName
                    ResourceGroup       = $_.ResourceGroup
                    Region              = $_.Region
                    StorageType         = $_.StorageType
                    DatastoreType       = $_.DatastoreType
                    BackupStorageUsedGB = $_.BackupStorageUsedGB
                    BackupStorageUsedTB = $_.BackupStorageUsedTB
                    StorageDetail       = $_.StorageDetail
                }
            }
            Add-ResourceTypeSheet -XlsxPath $xlsxPath -RawSheetName 'BackupVault-Raw' -PivotSheetName 'BackupVault-Pivot' `
                -PivotTitle 'BkVault_Summary' -Data $bkVaultExcel -PivotRows @('Subscription','Region') `
                -PivotData @{BackupStorageUsedGB='Sum'; VaultName='Count'} -ChartTitle 'Backup Vault Storage by Subscription (GB)'
        }

        # Backup Instances Tab
        if ($Selected.BACKUP -and $BackupInstances.Count) {
            $bkExcel = $BackupInstances | ForEach-Object {
                [PSCustomObject]@{
                    Subscription           = $_.Subscription
                    VaultName              = $_.VaultName
                    InstanceName           = $_.FriendlyName
                    DatasourceType         = $_.DatasourceType
                    ResourceName           = $_.ResourceName
                    ProtectionStatus       = $_.ProtectionStatus
                    CurrentProtectionState = $_.CurrentProtectionState
                    SourceResourceId       = $_.SourceResourceId
                }
            }
            Add-ResourceTypeSheet -XlsxPath $xlsxPath -RawSheetName 'Backup-Instances' -PivotSheetName 'BkInst-Pivot' `
                -PivotTitle 'BkInst_Summary' -Data $bkExcel -PivotRows @('Subscription','DatasourceType') `
                -PivotData @{InstanceName='Count'} -ChartTitle 'Backup Instances by Subscription and Datasource Type'
        }

        # Backup Vault Policies Tab (Improvement #4)
        if ($BackupVaultPolicies.Count -gt 0) {
            Add-ResourceTypeSheet -XlsxPath $xlsxPath -RawSheetName 'BkVault-Policies' -PivotSheetName 'BkPol-Pivot' `
                -PivotTitle 'BkPol_Summary' -Data $BackupVaultPolicies -PivotRows @('Subscription','DatasourceType') `
                -PivotData @{PolicyName='Count'} -ChartTitle 'Backup Vault Policies by Datasource'
        }

        # Disk Snapshots Tab
        if ($Selected.SNAPSHOT -and $DiskSnapshots.Count) {
            $snapExcel = $DiskSnapshots | ForEach-Object {
                [PSCustomObject]@{
                    Subscription        = $_.Subscription
                    SnapshotName        = $_.SnapshotName
                    ResourceGroup       = $_.ResourceGroup
                    Region              = $_.Region
                    DiskSizeGB          = $_.DiskSizeGB
                    DiskSizeTB          = $_.DiskSizeTB
                    TimeCreated         = $_.TimeCreated
                    SourceResourceId    = $_.SourceResourceId
                    CreateOption        = $_.CreateOption
                    OSType              = $_.OSType
                    SKU                 = $_.SKU
                    Incremental         = $_.Incremental
                }
            }
            Add-ResourceTypeSheet -XlsxPath $xlsxPath -RawSheetName 'Snapshot-RawData' -PivotSheetName 'Snapshot-Pivot' `
                -PivotTitle 'Snapshot_Summary' -Data $snapExcel -PivotRows @('Subscription','Region') `
                -PivotData @{DiskSizeGB='Sum'; SnapshotName='Count'} -ChartTitle 'Disk Snapshot Capacity by Subscription (GB)'
        }

        # VM Restore Points Tab (Improvement #8)
        if ($VMRestorePoints.Count -gt 0) {
            Add-ResourceTypeSheet -XlsxPath $xlsxPath -RawSheetName 'VMRestorePoints' -PivotSheetName 'VMRP-Pivot' `
                -PivotTitle 'VMRP_Summary' -Data $VMRestorePoints -PivotRows @('Subscription','Region') `
                -PivotData @{TotalDiskSizeGB='Sum'; CollectionName='Count'} -ChartTitle 'VM Restore Points Disk Size (GB)'
        }

        # ASR Replicated Items Tab (Improvement #9: with disk sizes)
        if ($Selected.ASR -and $ASRReplicatedItems.Count) {
            $asrExcel = $ASRReplicatedItems | ForEach-Object {
                [PSCustomObject]@{
                    Subscription               = $_.Subscription
                    VaultName                  = $_.VaultName
                    FriendlyName               = $_.FriendlyName
                    ProtectionState            = $_.ProtectionState
                    ProtectionStateDescription = $_.ProtectionStateDescription
                    ActiveLocation             = $_.ActiveLocation
                    ReplicationHealth          = $_.ReplicationHealth
                    FailoverHealth             = $_.FailoverHealth
                    TestFailoverState          = $_.TestFailoverState
                    PrimaryFabric              = $_.PrimaryFabric
                    RecoveryFabric             = $_.RecoveryFabric
                    ProtectedItemType          = $_.ProtectedItemType
                    SourceVmId                 = $_.SourceVmId
                    ReplicaDiskCount           = $_.ReplicaDiskCount
                    ReplicaDiskSizeGB          = $_.ReplicaDiskSizeGB
                }
            }
            Add-ResourceTypeSheet -XlsxPath $xlsxPath -RawSheetName 'ASR-RawData' -PivotSheetName 'ASR-Pivot' `
                -PivotTitle 'ASR_Summary' -Data $asrExcel -PivotRows @('Subscription','ProtectionState') `
                -PivotData @{ReplicaDiskSizeGB='Sum'; FriendlyName='Count'} -ChartTitle 'ASR Replicated Items by Subscription'
        }

        # Summary Tab (last)
        if ($summaryRows.Count -gt 0) {
            $summaryRows | Export-Excel -Path $xlsxPath -WorksheetName 'Summary' `
                -AutoSize -AutoFilter -FreezeTopRow -BoldTopRow
            Write-Host "  Tab: Summary" -ForegroundColor DarkCyan
        }

        if ($tabsCreated -gt 0) {
            Write-Host "  azure_sizing_executive_$dateStr.xlsx ($tabsCreated tabs + Summary)" -ForegroundColor Cyan
        }
    } catch {
        Write-Warning "Excel report generation failed: $($_.Exception.Message)"
        Write-Warning "CSV files were still generated successfully."
    }
} else {
    Write-Host "`nImportExcel module not available. Skipping .xlsx report." -ForegroundColor Yellow
}

# ============================================================================
# SECTION 11: ZIP ARCHIVE AND CLEANUP
# ============================================================================

Stop-Transcript

$zipFile = Join-Path $OutputPath "azure_sizing_$dateStr.zip"
Add-Type -AssemblyName System.IO.Compression.FileSystem
[IO.Compression.ZipFile]::CreateFromDirectory($outDir, $zipFile)

Remove-Item -Path $outDir -Recurse -Force

$elapsed = (Get-Date) - $scriptStart

Write-Host "`n============================================================" -ForegroundColor Green
Write-Host " Inventory complete!" -ForegroundColor Green
Write-Host " Results: $zipFile" -ForegroundColor Green
Write-Host " Elapsed: $($elapsed.ToString('hh\:mm\:ss'))" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Green

