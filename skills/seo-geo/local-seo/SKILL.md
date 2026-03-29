---
name: local-seo
description: "Use when the user says 'local SEO', 'Google Business Profile', 'local search', 'NAP consistency', 'local listings', 'Google Maps', 'local pack', or is optimizing a business for local search results and map visibility. Do NOT use for general SEO audits (see site-audit) or national keyword research (see keyword-research)."
---

# 📍 Local SEO — Local Search & Map Visibility
*Optimize a business for local search results and Google Maps visibility — covering Google Business Profile, NAP consistency, local schema markup, location pages, citations, reviews, and local link building — producing a scored audit report with prioritized action items.*

## Activation

When this skill activates, output:

`📍 Local SEO — Optimizing your local presence...`

| Context | Status |
|---------|--------|
| **User says "local SEO", "Google Business Profile", "local search"** | ACTIVE |
| **User says "NAP consistency", "local listings", "Google Maps"** | ACTIVE |
| **User says "local pack", "map pack", "local rankings"** | ACTIVE |
| **User wants to optimize a business for local search visibility** | ACTIVE |
| **User asks about Google Business Profile setup or optimization** | ACTIVE |
| **User asks about local citations or directory listings** | ACTIVE |
| **User wants a general/national SEO audit** | DORMANT — see site-audit |
| **User wants national keyword research only** | DORMANT — see keyword-research |
| **User wants schema markup without local context** | DORMANT — see schema-markup |
| **User wants meta tag optimization only** | DORMANT — see meta-tag-optimizer |

---

## Protocol

### Step 1: Gather Inputs

Ask the user for the following. Items marked **(required)** must be answered before proceeding; others improve audit depth.

- **Business name** (required): Exact legal/trading name
- **Address** (required): Full street address, city, state, ZIP
- **Phone number** (required): Primary business phone (local number preferred)
- **Website URL** (required): The root domain (e.g., `https://example.com`)
- **Business type** (required): Industry/vertical (e.g., plumber, dentist, restaurant, law firm)
- **Service area**: Cities, counties, or radius served beyond the physical location
- **Business hours**: Operating hours for each day of the week, including holidays
- **GBP categories**: Current primary and secondary categories (if known)
- **Existing GBP status**: Claimed? Verified? How long active? Current review count/rating?
- **Number of locations**: Single location or multi-location?
- **Competitors**: 2-3 local competitor business names or URLs
- **Target keywords**: Top 5-10 local search terms (e.g., "plumber in Austin TX", "best dentist near me")
- **Known issues**: Recent listing suspensions, duplicate listings, address changes, negative reviews?

**If the user provides only a business name and website**, proceed with reasonable defaults and note assumptions in the report.

---

### Step 2: Google Business Profile Optimization

Google Business Profile (GBP) is the single most important local ranking factor. A fully optimized profile directly impacts Local Pack and Maps visibility.

#### 2a: Profile Completeness

**Checklist — every field must be filled:**
- [ ] Business name matches the real-world name exactly (no keyword stuffing)
- [ ] Address is correct and matches the website and all citations
- [ ] Phone number is a local number (not toll-free unless that is the only number)
- [ ] Website URL points to the correct page (homepage for single-location, location page for multi-location)
- [ ] Business hours are accurate and include special/holiday hours
- [ ] Business description is present (750 characters max, use full allotment)
- [ ] Profile is verified (postcard, phone, email, or video verification)
- [ ] "From the business" description includes primary keywords naturally

**Red flags:**
- Business name contains keywords that are not part of the legal name (e.g., "Joe's Plumbing - Best Plumber in Austin TX") — this violates Google guidelines and risks suspension
- Address is a virtual office, PO Box, or UPS Store — Google penalizes these
- Multiple profiles for the same location — duplicates dilute rankings

#### 2b: Category Selection

Categories are the strongest on-profile ranking signal. Choose them carefully.

**Primary category** — must be the most specific match for the core business:

| Business Type | Correct Primary Category | Wrong Choice |
|---------------|------------------------|--------------|
| Emergency plumber | Plumber | Home improvement store |
| Family dentist | Dentist | Medical clinic |
| Italian restaurant | Italian restaurant | Restaurant |
| Personal injury attorney | Personal injury attorney | Lawyer |
| Hair salon | Hair salon | Beauty salon |
| Dog groomer | Pet groomer | Pet store |

**Secondary categories** — add every relevant category (up to 9 additional):

| Primary | Good Secondary Categories |
|---------|--------------------------|
| Plumber | Water heater installation service, Drain cleaning service, Bathroom remodeler |
| Dentist | Cosmetic dentist, Pediatric dentist, Dental implants provider, Emergency dental service |
| Italian restaurant | Pizza restaurant, Catering food and drink supplier, Bar |
| Personal injury attorney | Car accident lawyer, Wrongful death attorney, Workers' compensation attorney |

**How to research categories:**
1. Search your primary keyword on Google Maps
2. Click on each top-3 competitor
3. Use the GMB Category tool (pleper.com) or search `site:support.google.com GBP categories` for the full list
4. Select every category that honestly applies — more categories = more search triggers

#### 2c: Business Description Optimization

Write a 750-character description that:
- Opens with the primary keyword and location in the first sentence
- Lists core services/specialties
- Mentions the service area
- Includes a call-to-action
- Does NOT contain URLs, all-caps, or promotional language (Google may reject it)

**Example for a plumber in Austin:**

> ABC Plumbing is Austin's trusted plumbing service, serving homeowners and businesses across Travis County since 2005. We specialize in emergency plumbing repairs, water heater installation, drain cleaning, sewer line repair, and bathroom remodeling. Our licensed plumbers are available 24/7 for burst pipes, gas line leaks, and water damage emergencies. We serve Austin, Round Rock, Cedar Park, Pflugerville, and Georgetown. Call today for a free estimate on your next plumbing project.

#### 2d: Attributes

GBP attributes provide additional ranking signals and filter options. Set all applicable:

- **Identity attributes**: Black-owned, women-owned, veteran-owned, LGBTQ+ friendly
- **Accessibility**: Wheelchair accessible entrance, restroom, seating
- **Service options**: Online appointments, onsite services, in-store shopping, curbside pickup, delivery
- **Health & safety**: Mask required, temperature checks (if applicable)
- **Amenities**: Wi-Fi, outdoor seating, parking, restrooms
- **Payments**: NFC mobile payments, credit cards, debit cards, cash only

#### 2e: Photos Strategy

Businesses with 100+ photos receive 520% more calls and 2,717% more direction requests than the average (Google data).

**Photo targets:**

| Photo Type | Minimum Count | Notes |
|-----------|---------------|-------|
| Exterior (building, signage) | 3-5 | Different angles, day and night |
| Interior | 5-10 | Waiting area, workspaces, ambiance |
| Team/staff | 3-5 | Humanizes the business |
| Products/services | 10-20 | Food dishes, completed projects, equipment |
| Customer interactions | 5-10 | With permission — shows activity |
| Videos | 1-3 | 30-second walkthroughs, service demos |

**Photo optimization:**
- Geotag all photos with the business GPS coordinates before uploading
- Use EXIF data with business name in the file description
- File names should be descriptive: `austin-plumber-kitchen-remodel.jpg` not `IMG_4392.jpg`
- Upload at least 1 new photo per week to signal activity
- Respond to customer-uploaded photos (engage with the community tab)

#### 2f: Q&A Management

The Q&A section is publicly editable — anyone can ask and anyone can answer.

**Strategy:**
1. Seed 10-15 common questions and answer them yourself (as the business owner)
2. Questions should match real customer inquiries and include keywords
3. Monitor weekly — upvote helpful answers, flag spam
4. Never leave a question unanswered for more than 48 hours

**Example seeded Q&As for a dentist:**
- Q: "Do you accept Delta Dental insurance?" A: "Yes, we accept Delta Dental, Cigna, Aetna, MetLife, and most major dental plans. Call us at (512) 555-1234 to verify your specific plan."
- Q: "Do you offer emergency dental appointments?" A: "Yes, we offer same-day emergency dental appointments for toothaches, broken teeth, and dental trauma. Call us immediately at (512) 555-1234."
- Q: "What age do you start seeing children?" A: "We recommend bringing children in for their first dental visit by age 1 or when their first tooth appears. Our pediatric dental team specializes in making kids feel comfortable."

#### 2g: Google Posts Strategy

Google Posts appear directly on the GBP panel and signal business activity.

**Posting cadence:** Minimum 1 post per week. Posts expire after 7 days (event posts last until the event date).

| Post Type | Use For | CTA Button |
|-----------|---------|------------|
| What's New | General updates, tips, news | Learn more |
| Offer | Discounts, promotions, coupons | Redeem offer |
| Event | Workshops, open houses, seasonal events | Sign up / Learn more |
| Product | Feature specific products or services | Order online / Buy |

**Post optimization:**
- Include a high-quality image (1200x900px minimum)
- First 100 characters appear in preview — front-load the value
- Include the target keyword and location naturally
- Always add a CTA button linking to a relevant landing page
- Track clicks using UTM parameters: `?utm_source=google&utm_medium=gbp&utm_campaign=posts`

#### 2h: Products, Services & Menu

Depending on business type, populate the appropriate section:

- **Service businesses**: Add every service with description, price range, and category grouping
- **Retail/e-commerce**: Add products with photos, prices, descriptions, and purchase links
- **Restaurants**: Use the Menu editor — add every menu item with price and description
- **Healthcare**: Add services and accepted insurance plans

Each entry is an additional keyword signal and a potential search trigger.

---

### Step 3: NAP Consistency Audit

NAP (Name, Address, Phone) consistency across the web is a foundational local ranking signal. Inconsistencies confuse search engines and reduce trust.

#### 3a: Website NAP Verification

```bash
# Check NAP on the website — should appear in footer on every page
curl -s https://example.com/ | grep -oP '(\(\d{3}\)\s*\d{3}[-.\s]?\d{4}|\d{3}[-.\s]\d{3}[-.\s]\d{4})'
curl -s https://example.com/contact | grep -oP '(\(\d{3}\)\s*\d{3}[-.\s]?\d{4}|\d{3}[-.\s]\d{3}[-.\s]\d{4})'

# Check for address in footer/contact page
curl -s https://example.com/ | grep -i "street\|avenue\|blvd\|suite\|floor"

# Verify NAP in structured data
curl -s https://example.com/ | grep -oP '<script type="application/ld\+json">.*?</script>' | head -5
```

**Consistency rules:**
- Business name must be identical everywhere — "Joe's Plumbing" vs "Joe's Plumbing LLC" vs "Joes Plumbing" are three different entities to search engines
- Address format must be standardized — pick one format and use it everywhere:
  - `123 Main Street, Suite 200` (not "123 Main St Ste 200" or "123 Main St. #200")
- Phone format must be consistent — `(512) 555-1234` everywhere, not `512-555-1234` on some and `5125551234` on others
- Use USPS standardized address format as the canonical version

#### 3b: Major Citation Sources Audit

Check NAP consistency across these platforms. Listed by priority:

**Tier 1 — Must be claimed, verified, and accurate:**

| Platform | URL | Priority |
|----------|-----|----------|
| Google Business Profile | business.google.com | Critical |
| Apple Maps / Apple Business Connect | businessconnect.apple.com | Critical |
| Bing Places | bingplaces.com | High |
| Facebook Business | facebook.com/business | High |
| Yelp | biz.yelp.com | High |
| Better Business Bureau | bbb.org | High |

**Tier 2 — Important for citation volume:**

| Platform | URL | Notes |
|----------|-----|-------|
| Yellow Pages | yellowpages.com | Feeds dozens of smaller directories |
| Foursquare | foursquare.com | Powers Bing, Apple Maps, Uber, many apps |
| Nextdoor | nextdoor.com | Hyper-local recommendations |
| Manta | manta.com | Business directory |
| Hotfrog | hotfrog.com | Free business listing |
| CitySearch | citysearch.com | Local business reviews |
| MapQuest | mapquest.com | Maps and directions |
| Superpages | superpages.com | Online yellow pages |
| WhitePages | whitepages.com | Contact info directory |

**Tier 3 — Industry-specific (select by vertical):**

| Industry | Key Citation Sources |
|----------|---------------------|
| **Restaurants** | TripAdvisor, OpenTable, Zomato, DoorDash, Uber Eats, Grubhub, Yelp Reservations |
| **Healthcare** | Healthgrades, Zocdoc, Vitals, WebMD, RateMDs, CareDash, Wellness.com |
| **Dental** | 1-800-Dentist, DentistDirectory.com, Smile Guide, Dental Plans |
| **Legal** | Avvo, FindLaw, Justia, Lawyers.com, Martindale-Hubbell, Super Lawyers, Nolo |
| **Real Estate** | Zillow, Realtor.com, Redfin, Homes.com, Trulia, Compass |
| **Home Services** | Angi (HomeAdvisor), Thumbtack, Houzz, Porch, HomeStars, BuildZoom |
| **Automotive** | CarFax, AutoTrader, Cars.com, RepairPal, Mechanic Advisor |
| **Hotels/Lodging** | Booking.com, TripAdvisor, Hotels.com, Expedia, Kayak |
| **Fitness** | ClassPass, Mindbody, GymBird, Gym Navigator |
| **Financial** | NerdWallet, Bankrate, Investopedia advisor directory, NAPFA |
| **Veterinary** | VetRatingz, AAHA hospital locator, PetDesk |

#### 3c: Data Aggregator Submissions

Four major data aggregators feed NAP information to hundreds of directories and apps. Submitting correct data to all four is the most efficient way to fix widespread inconsistencies.

| Aggregator | Coverage | Submission |
|-----------|----------|------------|
| **Data Axle (Infogroup)** | Powers 70+ directories including YP, Superpages, CitySearch | dataaxle.com |
| **Neustar Localeze** | Feeds Bing, Apple Maps, Yahoo, 911 databases | neustarlocaleze.biz |
| **Foursquare** | Powers Bing, Apple Maps, Uber, Samsung, 150+ apps | foursquare.com/add-a-place |
| **Factual (now Foursquare)** | Merged with Foursquare — submit once via Foursquare | foursquare.com |

**Recommended workflow:**
1. Submit correct NAP to all four aggregators
2. Wait 2-4 weeks for propagation
3. Audit Tier 1 and Tier 2 citations for accuracy
4. Manually fix any remaining inconsistencies
5. Re-audit quarterly

#### 3d: Inconsistency Detection and Cleanup

**Common inconsistencies and how they happen:**

| Inconsistency | Root Cause | Fix |
|---------------|-----------|-----|
| Old phone number on directories | Number changed, listings not updated | Update each listing manually or via aggregator |
| "Street" vs "St" vs "St." | Different entry formats | Standardize to USPS format everywhere |
| Business name variations | Different people submitted listings | Claim and edit each listing |
| Old address on 50+ directories | Business moved, didn't update citations | Aggregator submission + manual top-20 fix |
| Duplicate listings on Google Maps | Multiple submissions over time | Merge or delete duplicates via GBP dashboard |
| Suite/unit number missing | Shortened during data entry | Add full address to all listings |

**Detection method — manual scan:**

```bash
# Search for your business name across major directories
# Look for inconsistencies in name, address, or phone number

# Check Google for NAP variations
# Search: "business name" "old phone number"
# Search: "business name" "old address"
# Search: "business name" -site:yourwebsite.com

# Tool recommendations for automated scanning:
# - Moz Local (free check, paid cleanup): moz.com/local
# - BrightLocal (citation tracker): brightlocal.com
# - Whitespark (citation finder): whitespark.ca
# - Yext (enterprise): yext.com
```

**Priority cleanup order:**
1. Google Business Profile (highest impact)
2. Apple Maps / Bing Places
3. Facebook / Yelp
4. Data aggregators (fixes cascade to dozens of sites)
5. Industry-specific directories
6. Everything else

---

### Step 4: Local Schema Markup

Structured data helps search engines understand business information and powers rich results (knowledge panels, map listings, business info boxes).

#### 4a: LocalBusiness JSON-LD — Complete Implementation

This is the foundational schema every local business needs on every page (typically in the site-wide header or footer).

```json
{
  "@context": "https://schema.org",
  "@type": "Plumber",
  "@id": "https://example.com/#organization",
  "name": "ABC Plumbing",
  "alternateName": "ABC Plumbing Services",
  "description": "Licensed plumber in Austin, TX providing emergency plumbing, water heater installation, drain cleaning, and bathroom remodeling since 2005.",
  "url": "https://example.com",
  "logo": "https://example.com/images/logo.png",
  "image": [
    "https://example.com/images/storefront.jpg",
    "https://example.com/images/team.jpg",
    "https://example.com/images/service-van.jpg"
  ],
  "telephone": "+1-512-555-1234",
  "email": "info@example.com",
  "foundingDate": "2005-03-15",
  "priceRange": "$$",
  "currenciesAccepted": "USD",
  "paymentAccepted": "Cash, Credit Card, Check",
  "address": {
    "@type": "PostalAddress",
    "streetAddress": "123 Main Street, Suite 200",
    "addressLocality": "Austin",
    "addressRegion": "TX",
    "postalCode": "78701",
    "addressCountry": "US"
  },
  "geo": {
    "@type": "GeoCoordinates",
    "latitude": 30.2672,
    "longitude": -97.7431
  },
  "hasMap": "https://www.google.com/maps?cid=GOOGLE_CID_NUMBER",
  "openingHoursSpecification": [
    {
      "@type": "OpeningHoursSpecification",
      "dayOfWeek": ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"],
      "opens": "07:00",
      "closes": "18:00"
    },
    {
      "@type": "OpeningHoursSpecification",
      "dayOfWeek": "Saturday",
      "opens": "08:00",
      "closes": "14:00"
    },
    {
      "@type": "OpeningHoursSpecification",
      "dayOfWeek": "Sunday",
      "opens": "00:00",
      "closes": "00:00",
      "description": "Closed (emergency service available)"
    }
  ],
  "areaServed": [
    {
      "@type": "City",
      "name": "Austin",
      "sameAs": "https://en.wikipedia.org/wiki/Austin,_Texas"
    },
    {
      "@type": "City",
      "name": "Round Rock"
    },
    {
      "@type": "City",
      "name": "Cedar Park"
    },
    {
      "@type": "City",
      "name": "Pflugerville"
    },
    {
      "@type": "City",
      "name": "Georgetown"
    }
  ],
  "sameAs": [
    "https://www.facebook.com/abcplumbing",
    "https://www.instagram.com/abcplumbing",
    "https://www.yelp.com/biz/abc-plumbing-austin",
    "https://www.bbb.org/us/tx/austin/profile/plumber/abc-plumbing-0825-1234567",
    "https://nextdoor.com/pages/abc-plumbing-austin-tx"
  ],
  "aggregateRating": {
    "@type": "AggregateRating",
    "ratingValue": "4.8",
    "reviewCount": "247",
    "bestRating": "5"
  },
  "review": [
    {
      "@type": "Review",
      "author": {
        "@type": "Person",
        "name": "John D."
      },
      "datePublished": "2026-02-15",
      "reviewBody": "ABC Plumbing fixed our burst pipe within an hour of calling. Professional, clean, and fair pricing. Highly recommend!",
      "reviewRating": {
        "@type": "Rating",
        "ratingValue": "5",
        "bestRating": "5"
      }
    }
  ],
  "hasOfferCatalog": {
    "@type": "OfferCatalog",
    "name": "Plumbing Services",
    "itemListElement": [
      {
        "@type": "OfferCatalog",
        "name": "Emergency Services",
        "itemListElement": [
          {
            "@type": "Offer",
            "itemOffered": {
              "@type": "Service",
              "name": "Emergency Pipe Repair",
              "description": "24/7 emergency burst pipe and leak repair"
            }
          },
          {
            "@type": "Offer",
            "itemOffered": {
              "@type": "Service",
              "name": "Gas Line Leak Repair",
              "description": "Emergency gas line detection and repair"
            }
          }
        ]
      },
      {
        "@type": "OfferCatalog",
        "name": "Installation Services",
        "itemListElement": [
          {
            "@type": "Offer",
            "itemOffered": {
              "@type": "Service",
              "name": "Water Heater Installation",
              "description": "Tank and tankless water heater installation and replacement"
            }
          }
        ]
      }
    ]
  }
}
```

#### 4b: Choosing the Correct @type

Do not use the generic `LocalBusiness` type. Schema.org has 100+ specific subtypes:

| Business Category | Schema @type |
|------------------|-------------|
| Plumber | `Plumber` |
| Electrician | `Electrician` |
| HVAC | `HVACBusiness` |
| Locksmith | `Locksmith` |
| Dentist | `Dentist` |
| Physician | `Physician` |
| Veterinarian | `VeterinaryCare` |
| Attorney/Lawyer | `Attorney` |
| Accountant | `AccountingService` |
| Insurance agent | `InsuranceAgency` |
| Real estate agent | `RealEstateAgent` |
| Restaurant | `Restaurant` |
| Bar | `BarOrPub` |
| Cafe | `CafeOrCoffeeShop` |
| Bakery | `Bakery` |
| Hair salon | `HairSalon` |
| Spa | `DaySpa` |
| Gym / fitness | `HealthClub` |
| Auto repair | `AutoRepair` |
| Auto dealer | `AutoDealer` |
| Hotel | `Hotel` |
| Store (general) | `Store` |
| Clothing store | `ClothingStore` |
| Hardware store | `HardwareStore` |
| Florist | `Florist` |
| Pet store | `PetStore` |
| Child care | `ChildCare` |
| Library | `Library` |
| School | `School` |

Full list: [schema.org/LocalBusiness subtypes](https://schema.org/LocalBusiness#subtypes)

#### 4c: Multiple Locations Schema

For multi-location businesses, use an `Organization` wrapper with `department` or `subOrganization`:

```json
{
  "@context": "https://schema.org",
  "@type": "Organization",
  "@id": "https://example.com/#organization",
  "name": "ABC Plumbing",
  "url": "https://example.com",
  "logo": "https://example.com/images/logo.png",
  "department": [
    {
      "@type": "Plumber",
      "@id": "https://example.com/locations/austin/#location",
      "name": "ABC Plumbing - Austin",
      "url": "https://example.com/locations/austin/",
      "telephone": "+1-512-555-1234",
      "address": {
        "@type": "PostalAddress",
        "streetAddress": "123 Main Street",
        "addressLocality": "Austin",
        "addressRegion": "TX",
        "postalCode": "78701",
        "addressCountry": "US"
      },
      "geo": {
        "@type": "GeoCoordinates",
        "latitude": 30.2672,
        "longitude": -97.7431
      },
      "openingHoursSpecification": [
        {
          "@type": "OpeningHoursSpecification",
          "dayOfWeek": ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"],
          "opens": "07:00",
          "closes": "18:00"
        }
      ]
    },
    {
      "@type": "Plumber",
      "@id": "https://example.com/locations/round-rock/#location",
      "name": "ABC Plumbing - Round Rock",
      "url": "https://example.com/locations/round-rock/",
      "telephone": "+1-512-555-5678",
      "address": {
        "@type": "PostalAddress",
        "streetAddress": "456 Commerce Blvd",
        "addressLocality": "Round Rock",
        "addressRegion": "TX",
        "postalCode": "78664",
        "addressCountry": "US"
      },
      "geo": {
        "@type": "GeoCoordinates",
        "latitude": 30.5083,
        "longitude": -97.6789
      }
    }
  ]
}
```

**Rules for multi-location schema:**
- Each location gets its own `LocalBusiness` schema on its dedicated location page
- The Organization schema on the homepage wraps all locations
- Each location must have a unique phone number, address, and URL
- Do not put all locations' schema on a single page — one location per page

#### 4d: Service Area Business Schema

For businesses that travel to customers (plumbers, locksmiths, mobile pet groomers) without a customer-facing storefront:

```json
{
  "@context": "https://schema.org",
  "@type": "Plumber",
  "name": "ABC Plumbing",
  "url": "https://example.com",
  "telephone": "+1-512-555-1234",
  "address": {
    "@type": "PostalAddress",
    "addressLocality": "Austin",
    "addressRegion": "TX",
    "postalCode": "78701",
    "addressCountry": "US"
  },
  "areaServed": {
    "@type": "GeoCircle",
    "geoMidpoint": {
      "@type": "GeoCoordinates",
      "latitude": 30.2672,
      "longitude": -97.7431
    },
    "geoRadius": "50000"
  }
}
```

**Alternative for specific service areas (city list):**

```json
"areaServed": [
  {
    "@type": "AdministrativeArea",
    "name": "Travis County, TX"
  },
  {
    "@type": "AdministrativeArea",
    "name": "Williamson County, TX"
  }
]
```

#### 4e: Validating Schema Markup

```bash
# Check for existing structured data on the site
curl -s https://example.com/ | grep -oP '<script type="application/ld\+json">.*?</script>' | \
  sed 's/<script type="application\/ld+json">//g; s/<\/script>//g' | jq '.' 2>/dev/null

# Validate with Google's Rich Results Test
# https://search.google.com/test/rich-results

# Validate with Schema.org validator
# https://validator.schema.org/
```

**Common schema errors:**
- Missing `geo` coordinates — required for Maps placement
- Using generic `LocalBusiness` instead of a specific subtype
- `telephone` not in E.164 format (`+1-512-555-1234`)
- `openingHoursSpecification` with wrong day format (must be full day name, not abbreviation)
- Mismatched NAP between schema and visible page content (Google treats this as deceptive)
- Missing `@id` for proper entity linking across pages

---

### Step 5: Local Content Strategy

Local content signals geographic relevance to search engines and captures long-tail local search queries.

#### 5a: Location Pages (Multi-Location Businesses)

Every physical location needs a dedicated, unique page. Do not use template pages with only the city name swapped.

**Required elements per location page:**

| Element | Purpose | Example |
|---------|---------|---------|
| Unique H1 | Location-specific headline | "Plumber in Austin, TX - ABC Plumbing" |
| Unique body content | 500-1,000 words about that location | Local team intro, neighborhood info, driving directions |
| NAP in text | Crawlable contact info | Full address, phone, hours in visible text |
| Embedded Google Map | Shows exact location | iframe embed from Google Maps |
| LocalBusiness schema | Structured data for this location | JSON-LD specific to this address |
| Photos | Location-specific images | Storefront, team, completed local projects |
| Reviews/testimonials | Social proof from that area | "Best plumber in Round Rock" testimonials |
| Service list | What this location offers | May differ slightly between locations |
| CTA | Conversion point | "Call our Austin team" or "Book online" |

**URL structure:**
- `example.com/locations/austin-tx/`
- `example.com/locations/round-rock-tx/`
- NOT: `example.com/locations?id=123`

#### 5b: Service Area Pages

For businesses serving multiple cities from one location, create city-specific landing pages:

**Template — adapt for each city:**

```
URL: /plumber-in-[city]-[state]/
H1: "Plumber in [City], [State] — [Business Name]"
Content:
  - Introduction referencing specific neighborhoods, landmarks, zip codes
  - Services available in that area
  - Response time to that area from your base location
  - Local customer testimonials
  - Common plumbing issues in that area (e.g., "Austin's clay soil causes frequent sewer line shifts")
  - Service area map showing coverage
  - NAP + click-to-call button
```

**Critical rule:** Each service area page must have genuinely unique content. Google penalizes doorway pages — thin pages that exist only for keyword targeting with swapped city names. Each page needs at minimum 300 words of unique, location-specific content.

**Good differentiation between pages:**
- Different customer testimonials from each city
- Specific neighborhoods mentioned
- Local landmarks used for directions
- Unique service mix if applicable (e.g., some areas have different water quality issues)
- Area-specific pricing differences
- Local regulations or permit information

#### 5c: Local Landing Pages for Specific Services

Combine service + location for high-intent queries:

| Target Query | Landing Page URL |
|-------------|-----------------|
| "emergency plumber Austin TX" | `/emergency-plumber-austin-tx/` |
| "water heater installation Round Rock" | `/water-heater-installation-round-rock-tx/` |
| "drain cleaning near me Cedar Park" | `/drain-cleaning-cedar-park-tx/` |

Each page should be 800-1,500 words covering the specific service in the specific location, with schema markup, NAP, and a strong CTA.

#### 5d: Community and Event Content

Local content that demonstrates community involvement:

- **Blog posts about local events:** "5 Things to Do in Austin This Weekend" (link bait for local shares)
- **Community involvement:** "ABC Plumbing Sponsors Austin Little League" (builds local backlinks)
- **Local guides:** "Austin Homeowner's Guide to Winterizing Pipes" (seasonal + local + topical)
- **Neighborhood spotlights:** "Why We Love Serving the Mueller Neighborhood" (hyper-local signals)
- **Local news/updates:** "New Water Restrictions in Travis County: What Homeowners Need to Know"
- **Case studies:** "How We Fixed a Major Slab Leak in Westlake Hills" (local + expertise)

#### 5e: Local Keyword Targeting

**Keyword patterns to target:**

| Pattern | Examples | Search Intent |
|---------|---------|---------------|
| `[service] in [city]` | "plumber in Austin" | Explicit local |
| `[service] near me` | "plumber near me" | Implicit local (proximity) |
| `best [service] [city]` | "best plumber Austin" | Research/comparison |
| `[service] [neighborhood]` | "plumber Mueller Austin" | Hyper-local |
| `[service] [zip code]` | "plumber 78701" | Zip-code local |
| `emergency [service] [city]` | "emergency plumber Austin" | Urgent local |
| `[service] open now` | "plumber open now" | Immediate need |
| `[service] reviews [city]` | "plumber reviews Austin" | Social proof seeking |
| `how much does [service] cost in [city]` | "how much does a plumber cost in Austin" | Price research |

---

### Step 6: Review Management

Reviews are the second most important local ranking factor after GBP optimization. They directly impact Local Pack rankings, click-through rates, and conversions.

#### 6a: Review Acquisition Strategies

**Ethical methods to increase review volume:**

1. **Ask at the point of delight** — immediately after completing a service, when the customer is happiest
2. **SMS/email follow-up** — send a review link 1-2 hours after service completion
3. **Review shortcut link** — create a direct link to the Google review form:
   ```
   https://search.google.com/local/writereview?placeid=YOUR_PLACE_ID
   ```
   Find your Place ID: https://developers.google.com/maps/documentation/places/web-service/place-id
4. **QR codes** — print on receipts, business cards, invoices, service vehicles
5. **"Leave us a review" page on your website** — a dedicated page with links to Google, Yelp, and industry-specific platforms
6. **In-store signage** — NFC tap-to-review tags, table tent cards, window stickers
7. **Post-purchase email sequence** — Day 1: "How was your experience?" → Day 3: "Would you leave us a review?"

**Never do:**
- Offer incentives for reviews (violates Google, Yelp, and FTC guidelines)
- Buy fake reviews
- Review-gate (only sending happy customers to review platforms)
- Ask for reviews on Yelp specifically (Yelp penalizes solicited reviews)

#### 6b: Review Response Templates

**Respond to every review within 24 hours.** Response rate and speed are ranking signals.

**Positive review response (5-star):**

> Thank you so much, [Name]! We're glad our team was able to [specific service mentioned] quickly for you. We appreciate you choosing ABC Plumbing and look forward to helping you again whenever you need us. - [Owner/Manager Name]

**Positive review response (4-star):**

> Thanks for the great review, [Name]! We're happy you were satisfied with our [service]. If there's anything we could have done to make it a 5-star experience, we'd love to hear — feel free to call us at (512) 555-1234. Thank you for your business!

**Negative review response (legitimate complaint):**

> [Name], thank you for sharing your feedback. We sincerely apologize that your experience with [specific issue] didn't meet our standards. We'd like to make this right — please contact [Owner/Manager Name] directly at (512) 555-1234 or email us at info@example.com so we can resolve this for you. Your satisfaction is our priority.

**Negative review response (unfair or exaggerated):**

> [Name], we take all feedback seriously. We've reviewed our records and would like to discuss the details of your experience. Please reach out to us directly at (512) 555-1234 so we can better understand what happened and work toward a resolution.

**Fake review response (suspected competitor or someone who was never a customer):**

> We appreciate all feedback; however, we have no record of serving a customer by this name. If you did visit us, please contact us at (512) 555-1234 with your service details so we can look into this. If this review was posted in error, we respectfully ask that it be removed.

Then flag the review through GBP as "fake/spam" and document the flagging.

**Response guidelines:**
- Always include the business name (keyword signal)
- Mention the service or location naturally
- Keep responses under 200 words
- Never argue, be defensive, or reveal customer details
- Move negative conversations offline (phone/email)
- Personalize each response — do not copy-paste the same reply for every review

#### 6c: Review Velocity Targets

| Business Stage | Target Reviews/Month | Notes |
|---------------|---------------------|-------|
| New business (0-20 reviews) | 5-10 | Build foundation quickly |
| Established (20-100 reviews) | 3-5 | Steady growth |
| Mature (100+ reviews) | 2-4 | Maintain freshness |
| Competitive market | Match or exceed top competitor's velocity | Monitor competitor review counts monthly |

**Recency matters:** Google weights recent reviews more heavily. A business with 50 reviews from the last 6 months will often outrank one with 200 reviews but none in the last year.

#### 6d: Review Schema Markup

Add `AggregateRating` to your LocalBusiness schema (shown in Step 4a). Additionally, individual reviews can be marked up:

```json
{
  "@context": "https://schema.org",
  "@type": "Plumber",
  "name": "ABC Plumbing",
  "aggregateRating": {
    "@type": "AggregateRating",
    "ratingValue": "4.8",
    "reviewCount": "247",
    "bestRating": "5",
    "worstRating": "1"
  },
  "review": [
    {
      "@type": "Review",
      "author": {
        "@type": "Person",
        "name": "Sarah M."
      },
      "datePublished": "2026-03-10",
      "reviewBody": "Called ABC Plumbing for a water heater replacement. Tech arrived within 2 hours, gave us options for tank vs tankless, and had the new unit installed by end of day. Very professional.",
      "reviewRating": {
        "@type": "Rating",
        "ratingValue": "5",
        "bestRating": "5"
      }
    }
  ]
}
```

**Important:** Google's review snippet guidelines require that reviews marked up in schema come from your own site, not scraped from third-party platforms. Self-serving fake review markup will result in a manual action.

#### 6e: Third-Party Review Platforms

Diversify review presence beyond Google:

| Platform | Best For | Notes |
|----------|---------|-------|
| Google Business Profile | All businesses | Primary platform, most SEO impact |
| Yelp | Restaurants, retail, home services | Don't solicit — Yelp filters solicited reviews |
| Facebook | All businesses | Recommendations format (thumbs up/down + text) |
| TripAdvisor | Travel, restaurants, attractions | Critical for hospitality |
| BBB | All businesses | Accreditation builds trust |
| Trustpilot | E-commerce, SaaS, online services | Good for non-local trust signals |
| Industry-specific | Varies by vertical | See citation sources in Step 3b |

**Platform priority rule:** Focus 70% of review acquisition efforts on Google, 20% on the primary industry platform, and 10% on everything else.

---

### Step 7: Local Link Building

Local backlinks signal geographic relevance and authority to search engines. Quality and local relevance outweigh quantity.

#### 7a: Local Citation Link Sources

Beyond directory listings (covered in Step 3), pursue these link opportunities:

**Local news and media:**
- Local newspaper websites (pitch stories, expert quotes, press releases)
- Local TV station websites (community calendar, business spotlights)
- Local online magazines and blogs
- Patch.com (hyper-local news)
- Local radio station community pages

**Local government and organizations:**
- City/county business directories
- Economic development organizations
- Convention and visitors bureaus
- Tourism boards
- Local government vendor/contractor lists

#### 7b: Community Partnerships

| Partnership Type | Link Opportunity | Example |
|-----------------|-----------------|---------|
| Chamber of Commerce | Member directory listing + event co-hosting | Join local and regional chambers — link on member page |
| Local nonprofits | Sponsor page, volunteer recognition | Sponsor a Habitat for Humanity build |
| Schools/universities | Scholarship page, career day, alumni spotlight | Create a $500 annual scholarship — permanent .edu link |
| Sports teams/leagues | Sponsor page on team website | Sponsor a little league team |
| Local events | Event page listing, sponsor recognition | Sponsor a local 5K, food festival, farmers market |
| Other local businesses | Cross-promotion, referral pages | Plumber and HVAC company refer each other |
| Coworking spaces | Member/partner directory | If relevant to service area |

#### 7c: Local PR and Content-Driven Links

**Strategies that earn links naturally:**

1. **Local data studies:** "We analyzed 1,000 plumbing calls in Austin — here are the most common issues by neighborhood" — local bloggers and news sites will cite this
2. **Expert commentary:** Reach out to local journalists and offer to be a quoted expert on relevant topics
3. **Community events hosting:** Host a free workshop ("How to Prevent Frozen Pipes This Winter") — get listed on event calendars
4. **Local awards and recognition:** Apply for "Best of Austin" awards — winners get listed and linked
5. **Crisis response content:** "What Austin Homeowners Need to Know After the February Ice Storm" — timely, shareable, linkable
6. **Resource guides:** "Complete Guide to Austin Building Permits for Home Renovation" — becomes a reference that others link to

#### 7d: Sponsorship Link Opportunities

| Sponsorship Type | Typical Cost | Link Value | Relevance Signal |
|-----------------|-------------|-----------|-----------------|
| Little League team | $200-500/season | Medium (team website) | Strong local signal |
| Local 5K/charity run | $250-1,000 | Medium-High (event page) | Community involvement |
| School event/program | $100-500 | High (.edu domain) | Education + local |
| Chamber event | $200-800 | Medium (chamber site) | Business community |
| Local podcast | $50-300/episode | Medium (podcast page + show notes) | Local authority |
| Community garden | $100-300 | Low-Medium | Neighborhood signal |
| Animal shelter event | $100-500 | Medium (shelter site) | Community goodwill |

#### 7e: Local Resource Page Link Building

Find resource pages on local websites that list businesses or services:

```bash
# Search for local resource pages that could link to you
# Google search operators:

# "[city] resources" + your industry
# "[city] recommended [service]"
# "[city] business directory"
# "best [service] in [city]" (listicles)
# site:.edu "[city]" "[service type]" "resources"
# site:.gov "[city]" "business directory"
# "[city] new homeowner guide" (often lists local services)
# "[city] relocation guide"
```

**Outreach template for resource pages:**

> Subject: Resource addition for your [City] [Topic] page
>
> Hi [Name],
>
> I noticed your [City] resource page at [URL] — great collection for local residents. I run [Business Name], a [service type] serving [City] since [year]. We have a [rating]-star rating on Google with [count]+ reviews.
>
> Would you consider adding us to your list? Our website is [URL] and we specialize in [brief service list].
>
> Thanks for maintaining such a helpful resource for the community.
>
> Best, [Name]

---

### Step 8: Output — Local SEO Audit Report

Generate the complete report in this format:

```
━━━ LOCAL SEO AUDIT REPORT ━━━━━━━━━━━━━━━━━

── BUSINESS OVERVIEW ──────────────────────────
Business:       [Business Name]
Address:        [Full Address]
Phone:          [Phone Number]
Website:        [URL]
Type:           [Business Type]
Service Area:   [Cities/Counties Served]
GBP Status:     [Claimed/Verified/Unverified]
GBP Rating:     [X.X stars, Y reviews]
Date Audited:   [Date]

── AUDIT SCORES ───────────────────────────────

  Google Business Profile:    [ ]/100
  NAP Consistency:            [ ]/100
  Schema Markup:              [ ]/100
  Local Content:              [ ]/100
  Review Profile:             [ ]/100
  Local Backlinks:            [ ]/100
  ─────────────────────────────
  OVERALL LOCAL SEO SCORE:    [ ]/100  (Grade: [ ])

── GOOGLE BUSINESS PROFILE ────────────────────
Profile Completeness:   [ ]%
Primary Category:       [Current] → Recommended: [Better option if applicable]
Secondary Categories:   [List current] → Missing: [Suggestions]
Description:            [Present/Missing/Needs optimization]
Photos:                 [Count] uploaded → Target: [100+]
Posts:                   [Last post date] → Target: [Weekly]
Q&A:                    [Count] questions → [Answered/Unanswered]
Products/Services:      [Listed/Missing]
Attributes:             [Set/Missing]

── NAP CONSISTENCY ────────────────────────────
Canonical NAP:
  Name:    [Standardized business name]
  Address: [USPS standardized address]
  Phone:   [Standard format]

Citation Status:
  Platform              Status    NAP Match   Action Needed
  Google Business       ✓/✗       ✓/✗         [Action]
  Apple Maps            ✓/✗       ✓/✗         [Action]
  Bing Places           ✓/✗       ✓/✗         [Action]
  Yelp                  ✓/✗       ✓/✗         [Action]
  Facebook              ✓/✗       ✓/✗         [Action]
  BBB                   ✓/✗       ✓/✗         [Action]
  Yellow Pages          ✓/✗       ✓/✗         [Action]
  [Industry-specific]   ✓/✗       ✓/✗         [Action]

  Consistent: [X] / Inconsistent: [Y] / Missing: [Z]

── SCHEMA MARKUP STATUS ───────────────────────
LocalBusiness schema:   [Present/Missing]
@type specificity:      [Generic LocalBusiness / Specific subtype]
Properties present:     [List]
Properties missing:     [List]
Validation errors:      [Count and details]

── LOCAL CONTENT ASSESSMENT ───────────────────
Location pages:         [Count] pages for [Count] locations
Service area pages:     [Count] covering [Count] service areas
Local blog content:     [Count] posts with local relevance
Content gaps:           [List of missing location/service pages]

── REVIEW PROFILE ─────────────────────────────
Google Reviews:         [Count] reviews, [X.X] average
Review Velocity:        [X] reviews/month (last 6 months)
Response Rate:          [X]% of reviews responded to
Avg Response Time:      [X] hours/days
Competitor Comparison:
  [Business]:  [Count] reviews, [Rating] avg
  [Comp A]:    [Count] reviews, [Rating] avg
  [Comp B]:    [Count] reviews, [Rating] avg

── LOCAL BACKLINK PROFILE ─────────────────────
Local referring domains: [Count]
Citation links:          [Count]
Community/sponsor links: [Count]
Local .edu/.gov links:   [Count]
Missing opportunities:   [List]

── CRITICAL ISSUES (Fix Immediately) ──────────
ID   Issue                              Impact   Effort
C1   [Issue description]                10       [1-10]
C2   [Issue description]                [7-10]   [1-10]

── HIGH PRIORITY ACTIONS ──────────────────────
ID   Issue                              Impact   Effort
H1   [Issue description]                [7-9]    [1-10]
H2   [Issue description]                [7-9]    [1-10]

── MEDIUM PRIORITY ACTIONS ────────────────────
ID   Issue                              Impact   Effort
M1   [Issue description]                [4-6]    [1-10]
M2   [Issue description]                [4-6]    [1-10]

── LOW PRIORITY ACTIONS ───────────────────────
ID   Issue                              Impact   Effort
L1   [Issue description]                [1-3]    [1-10]
L2   [Issue description]                [1-3]    [1-10]

── QUICK WINS (Do This Week) ──────────────────
1. [Action item with expected time]
2. [Action item with expected time]
3. [Action item with expected time]

── 90-DAY ACTION PLAN ─────────────────────────
Week 1:     [Critical fixes]
Weeks 2-3:  [GBP optimization + citation cleanup]
Weeks 4-6:  [Content creation — location/service area pages]
Weeks 7-8:  [Review acquisition campaign launch]
Weeks 9-12: [Local link building outreach]
Ongoing:    [Weekly GBP posts, monthly review monitoring, quarterly re-audit]

── CITATION LIST (Complete) ───────────────────
[Full list of directories to claim/update with URLs and current status]

── SCHEMA MARKUP CODE ─────────────────────────
[Complete JSON-LD ready to paste into the site header]

── TOOLS RECOMMENDED ──────────────────────────
- Google Business Profile (free) — primary listing management
- Google Search Console (free) — local search performance
- BrightLocal (paid) — citation tracking, local rank tracking
- Whitespark (paid) — citation finder, local rank tracker
- Moz Local (paid) — citation distribution and monitoring
- GatherUp or Podium (paid) — review acquisition automation
```

---

## Anti-Patterns

| Anti-Pattern | Why It's Wrong | Correct Approach |
|-------------|----------------|------------------|
| Keyword-stuffing the GBP business name | Violates Google guidelines; risks suspension | Use the exact legal/trading business name |
| Using a virtual office or PO Box address | Google detects and penalizes these; may trigger verification loop | Use a real physical location or set up as a service-area business |
| Creating duplicate GBP listings | Splits review equity and confuses rankings | Merge duplicates; one listing per physical location |
| Identical content on location pages with city names swapped | Google treats these as doorway pages — manual action risk | Write genuinely unique content for each location page |
| Ignoring NAP inconsistencies | Conflicting business info erodes search engine trust | Standardize NAP across every listing and the website |
| Buying fake reviews | Google detects patterns; penalties include review removal and listing suspension | Build reviews organically through service quality and systematic asking |
| Asking for Yelp reviews | Yelp's algorithm filters solicited reviews; can suppress genuine ones | Let Yelp reviews happen naturally; focus review solicitation on Google |
| Using generic LocalBusiness schema type | Misses ranking signal specificity; less likely to trigger rich results | Use the most specific Schema.org subtype for the business |
| Targeting "near me" in page content | "Near me" is a proximity signal, not a keyword — Google replaces it with the user's location | Target `[service] in [city]` patterns instead |
| Neglecting review responses | Low response rate signals disengagement to Google and potential customers | Respond to every review within 24 hours |
| Building service area pages before GBP is optimized | GBP drives 40%+ of local ranking signals; content alone won't compensate | Optimize GBP first, then layer in content and citations |
| Submitting to hundreds of low-quality directories | Spammy citations dilute trust signals | Focus on 30-50 high-quality, relevant citations |
| Ignoring photos and posts on GBP | Google rewards active, complete profiles with more visibility | Upload photos weekly and post at least once per week |
| Setting up schema but not validating it | Invalid schema is silently ignored by Google — no benefit at all | Validate with Google Rich Results Test after every change |

## Escalation

Hand off to a specialist or recommend paid tools when:

- **GBP listing is suspended** — reinstatement requires understanding Google's specific suspension reasons and appeals process, which can be complex and unforgiving
- **Multi-location business with 10+ locations** — manual management is unsustainable; recommend Yext, Rio SEO, or Uberall for centralized listing management
- **Franchise or multi-brand locations** — requires franchise-specific GBP policies and complex schema relationships
- **Fake review attacks** — sustained fake review campaigns require legal intervention (defamation claims) and systematic Google flagging with documentation
- **HIPAA/legal compliance** — healthcare and legal businesses have review response restrictions; a compliance officer should review response templates
- **International local SEO** — Google Business Profile differs by country; schema requires country-specific address formats; citation sources are entirely different
- **Local Service Ads (LSAs)** — Google's pay-per-lead ad product for local services requires separate setup and management
- **Ongoing rank tracking** — local rank tracking requires geo-grid tools (Local Falcon, BrightLocal) that check rankings from dozens of GPS coordinates across the service area
- **Map spam competitors** — competitors keyword-stuffing their GBP name or using fake addresses require Google Business redressal form filings with evidence

## Inputs

- Business name (required)
- Physical address (required)
- Phone number (required)
- Website URL (required)
- Business type/industry (required)
- Service area — cities, counties, or radius
- Business hours (all days, including holidays)
- GBP categories (current primary and secondaries)
- Existing GBP status (claimed, verified, review count/rating)
- Number of locations
- Competitor business names or URLs (2-3)
- Target local keywords (5-10)
- Known issues (suspensions, duplicates, address changes, negative reviews)

## Outputs

- Overall local SEO score (0-100) with letter grade
- Section-by-section scores (GBP, NAP, Schema, Content, Reviews, Links)
- Google Business Profile optimization checklist with specific action items
- NAP consistency audit table across all major citation sources
- Complete citation list with claim/update status for all relevant platforms
- Complete LocalBusiness JSON-LD schema markup ready to deploy
- Local content strategy with specific page recommendations and URL structures
- Review management plan with response templates and velocity targets
- Local link building opportunity list with outreach templates
- Prioritized action plan with impact/effort ratings
- Quick wins list (high impact, low effort fixes)
- 90-day phased implementation timeline
- Tool recommendations for ongoing local SEO management

## Level History

- **Lv.1** — Full implementation: Comprehensive 8-step local SEO protocol covering Google Business Profile optimization (completeness, categories, description, attributes, photos, Q&A, posts, products/services), NAP consistency audit (website verification, tier 1-3 citation sources by industry, data aggregator submissions, inconsistency detection and cleanup), local schema markup (complete LocalBusiness JSON-LD with all properties, specific @type selection, multi-location schema, service area schema, validation), local content strategy (location pages, service area pages, local landing pages, community content, local keyword patterns), review management (acquisition strategies, response templates for positive/negative/fake reviews, velocity targets, review schema, third-party platforms), local link building (citation sources, community partnerships, local PR, sponsorships, resource page outreach), and scored audit report with action items, citation list, and deployable schema code. Includes real JSON-LD examples, citation source lists by industry, anti-patterns, and escalation criteria. (Origin: MemStack skill replacement, Mar 2026)
