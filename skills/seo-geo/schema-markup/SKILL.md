---
name: schema-markup
description: "Use when the user says 'add schema', 'schema markup', 'JSON-LD', 'structured data', 'rich results', 'rich snippets', or is adding or fixing schema.org structured data for better search result appearance. Do NOT use for meta tag optimization (see meta-tag-optimizer) or full SEO audits (see site-audit)."
---

# 🧩 Schema Markup — Structured Data & Rich Results
*Identify applicable schema types, generate valid JSON-LD blocks, validate against Google's Rich Results requirements, and deliver implementation-ready structured data for any page type or CMS.*

## Activation

When this skill activates, output:

`🧩 Schema Markup — Adding structured data to your pages...`

| Context | Status |
|---------|--------|
| **User says "add schema", "schema markup", "JSON-LD", "structured data"** | ACTIVE |
| **User says "rich results", "rich snippets", "featured snippets schema"** | ACTIVE |
| **User wants to add or fix schema.org markup on their site** | ACTIVE |
| **User asks about star ratings, FAQ accordion, or recipe cards in search** | ACTIVE |
| **User has Google Search Console structured data errors** | ACTIVE |
| **User wants to generate JSON-LD for a specific page type** | ACTIVE |
| **User wants full SEO audit (not just schema)** | DORMANT — see site-audit |
| **User wants meta tag optimization only** | DORMANT — see meta-tag-optimizer |
| **User wants AI search / GEO optimization** | DORMANT — see ai-search-visibility |
| **User wants local SEO strategy (beyond LocalBusiness schema)** | DORMANT — see local-seo |

---

## Protocol

### Step 1: Gather Inputs

Ask the user for the following. Items marked **(required)** must be answered before proceeding; others improve the output.

- **Website URL** (required): The site to add structured data to (e.g., `https://example.com`)
- **Page types** (required): Which pages need schema? (homepage, product pages, blog posts, FAQ page, about page, contact page, event listings, recipe pages, course pages, etc.)
- **Business type**: What kind of organization? (Local business, e-commerce store, SaaS company, media/publisher, personal brand, nonprofit, restaurant, professional services, etc.)
- **Current schema status**: Does the site already have any structured data? If so, what types? Any known errors in Google Search Console?
- **Target rich results**: Which rich result types does the user want? (FAQ accordion, star ratings, recipe cards, how-to steps, event listings, product prices, sitelinks search box, breadcrumbs, etc.)
- **CMS / tech stack**: WordPress (Yoast/Rank Math?), Shopify, Next.js, Gatsby, static HTML, custom CMS?
- **Key business details**: Business name, address, phone, logo URL, social profiles, founding date — needed for Organization/LocalBusiness schema
- **Product details** (if e-commerce): Price, currency, availability, brand, SKU, review count/rating

**If the user provides only a URL**, fetch the page to inspect existing markup and infer page type, then proceed with reasonable defaults. Note assumptions in the output.

---

### Step 2: Schema Type Selection

Use this decision tree to map page types to schema types. A single page often needs multiple schema types layered together.

#### Primary Schema Type Matrix

| Page Type | Primary Schema | Supporting Schema | Rich Result Triggered |
|-----------|---------------|-------------------|----------------------|
| Homepage | `Organization` or `LocalBusiness` | `WebSite` + `SearchAction`, `BreadcrumbList` | Sitelinks search box, knowledge panel |
| About page | `Organization` or `Person` | `BreadcrumbList` | Knowledge panel |
| Blog post / Article | `Article` or `BlogPosting` | `BreadcrumbList`, `Person` (author), `ImageObject` | Article carousel, author byline |
| Product page | `Product` | `Offer`, `AggregateRating`, `Review`, `BreadcrumbList` | Product stars, price, availability |
| FAQ page | `FAQPage` | `Question` + `Answer`, `BreadcrumbList` | FAQ accordion in SERP |
| How-to guide | `HowTo` | `HowToStep`, `HowToTool`, `HowToSupply`, `ImageObject` | How-to steps with images |
| Recipe page | `Recipe` | `AggregateRating`, `NutritionInformation`, `VideoObject` | Recipe card with image, time, rating |
| Event page | `Event` | `Place`, `Offer`, `Organization` (performer/organizer) | Event listing with date, venue, price |
| Course / training | `Course` | `CourseInstance`, `Organization` (provider), `Offer` | Course listing with provider, price |
| Video page | `VideoObject` | `BreadcrumbList`, `Organization` (publisher) | Video carousel, key moments |
| Software / app | `SoftwareApplication` | `Offer`, `AggregateRating`, `Review` | Software listing with rating, price |
| Job posting | `JobPosting` | `Organization` (hiring), `Place` (location), `MonetaryAmount` | Job listing in Google for Jobs |
| Local business | `LocalBusiness` (or subtype) | `PostalAddress`, `GeoCoordinates`, `OpeningHoursSpecification` | Local pack, knowledge panel |
| Breadcrumbs | `BreadcrumbList` | `ListItem` | Breadcrumb trail in SERP |
| Service page | `Service` | `Organization`, `Offer`, `AggregateRating` | No dedicated rich result, but supports knowledge panel |
| Contact page | `ContactPage` | `Organization`, `PostalAddress` | No dedicated rich result |
| Review page | `Review` or `AggregateRating` | `Product`/`LocalBusiness` (itemReviewed) | Review stars |

#### Decision Flow

```
Is this a business homepage?
├── Yes → Organization + WebSite + SearchAction + BreadcrumbList
│   └── Has physical location? → LocalBusiness (subtype) instead of Organization
└── No → What content is on the page?
    ├── Product for sale → Product + Offer + AggregateRating
    ├── Article / blog → Article + Person (author) + BreadcrumbList
    ├── Questions & answers → FAQPage + Question/Answer pairs
    ├── Step-by-step instructions → HowTo + HowToStep
    ├── Recipe → Recipe + AggregateRating + NutritionInformation
    ├── Event → Event + Place + Offer
    ├── Video → VideoObject
    ├── Job listing → JobPosting + Organization
    ├── Course → Course + CourseInstance + Offer
    └── Software → SoftwareApplication + Offer + AggregateRating
```

**Always add `BreadcrumbList` to every page** — it is the highest-ROI schema type because it improves how every search result looks, regardless of page type.

---

### Step 3: JSON-LD Implementation

All structured data should use JSON-LD format injected in the `<head>` section. JSON-LD is Google's preferred format over Microdata or RDFa.

#### 3.1: Organization + WebSite (Homepage)

```json
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@graph": [
    {
      "@type": "Organization",
      "@id": "https://example.com/#organization",
      "name": "Example Company",
      "url": "https://example.com",
      "logo": {
        "@type": "ImageObject",
        "@id": "https://example.com/#logo",
        "url": "https://example.com/images/logo.png",
        "width": 600,
        "height": 60,
        "caption": "Example Company"
      },
      "image": { "@id": "https://example.com/#logo" },
      "description": "Brief company description for knowledge panel.",
      "foundingDate": "2020-01-15",
      "founder": {
        "@type": "Person",
        "name": "Jane Smith"
      },
      "contactPoint": {
        "@type": "ContactPoint",
        "telephone": "+1-555-123-4567",
        "contactType": "customer service",
        "availableLanguage": ["English"]
      },
      "sameAs": [
        "https://www.facebook.com/example",
        "https://www.twitter.com/example",
        "https://www.linkedin.com/company/example",
        "https://www.instagram.com/example",
        "https://www.youtube.com/@example"
      ]
    },
    {
      "@type": "WebSite",
      "@id": "https://example.com/#website",
      "url": "https://example.com",
      "name": "Example Company",
      "publisher": { "@id": "https://example.com/#organization" },
      "potentialAction": {
        "@type": "SearchAction",
        "target": {
          "@type": "EntryPoint",
          "urlTemplate": "https://example.com/search?q={search_term_string}"
        },
        "query-input": "required name=search_term_string"
      }
    }
  ]
}
</script>
```

#### 3.2: LocalBusiness

```json
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "Restaurant",
  "@id": "https://example.com/#localbusiness",
  "name": "Example Restaurant",
  "image": "https://example.com/images/storefront.jpg",
  "url": "https://example.com",
  "telephone": "+1-555-123-4567",
  "priceRange": "$$",
  "servesCuisine": ["Italian", "Mediterranean"],
  "address": {
    "@type": "PostalAddress",
    "streetAddress": "123 Main Street",
    "addressLocality": "Springfield",
    "addressRegion": "IL",
    "postalCode": "62701",
    "addressCountry": "US"
  },
  "geo": {
    "@type": "GeoCoordinates",
    "latitude": 39.7817,
    "longitude": -89.6501
  },
  "openingHoursSpecification": [
    {
      "@type": "OpeningHoursSpecification",
      "dayOfWeek": ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"],
      "opens": "11:00",
      "closes": "22:00"
    },
    {
      "@type": "OpeningHoursSpecification",
      "dayOfWeek": ["Saturday", "Sunday"],
      "opens": "10:00",
      "closes": "23:00"
    }
  ],
  "aggregateRating": {
    "@type": "AggregateRating",
    "ratingValue": "4.6",
    "reviewCount": "284"
  },
  "sameAs": [
    "https://www.facebook.com/examplerestaurant",
    "https://www.yelp.com/biz/example-restaurant"
  ]
}
</script>
```

**LocalBusiness subtypes** — always use the most specific subtype: `Restaurant`, `Dentist`, `LegalService`, `AutoRepair`, `BeautySalon`, `FinancialService`, `MedicalBusiness`, `RealEstateAgent`, `Plumber`, `Electrician`, `AccountingService`, etc. The full list is at https://schema.org/LocalBusiness.

#### 3.3: Article / BlogPosting

```json
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "Article",
  "@id": "https://example.com/blog/seo-guide/#article",
  "headline": "The Complete Guide to SEO in 2026",
  "description": "Learn everything about search engine optimization with this comprehensive, up-to-date guide covering technical SEO, content strategy, and link building.",
  "image": {
    "@type": "ImageObject",
    "url": "https://example.com/images/seo-guide-hero.jpg",
    "width": 1200,
    "height": 630
  },
  "author": {
    "@type": "Person",
    "@id": "https://example.com/#author-jane",
    "name": "Jane Smith",
    "url": "https://example.com/about/jane-smith",
    "jobTitle": "Head of SEO",
    "image": "https://example.com/images/jane-smith.jpg",
    "sameAs": [
      "https://twitter.com/janesmith",
      "https://linkedin.com/in/janesmith"
    ]
  },
  "publisher": { "@id": "https://example.com/#organization" },
  "datePublished": "2026-01-15",
  "dateModified": "2026-03-20",
  "mainEntityOfPage": {
    "@type": "WebPage",
    "@id": "https://example.com/blog/seo-guide/"
  },
  "wordCount": 4500,
  "inLanguage": "en-US"
}
</script>
```

#### 3.4: Product + Offer + AggregateRating

```json
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "Product",
  "@id": "https://example.com/products/widget-pro/#product",
  "name": "Widget Pro 3000",
  "image": [
    "https://example.com/images/widget-pro-1.jpg",
    "https://example.com/images/widget-pro-2.jpg",
    "https://example.com/images/widget-pro-3.jpg"
  ],
  "description": "The Widget Pro 3000 is a professional-grade widget with titanium construction and smart connectivity.",
  "sku": "WP3000-BLK",
  "mpn": "WP3000",
  "brand": {
    "@type": "Brand",
    "name": "WidgetCo"
  },
  "offers": {
    "@type": "Offer",
    "url": "https://example.com/products/widget-pro/",
    "priceCurrency": "USD",
    "price": "149.99",
    "priceValidUntil": "2026-12-31",
    "availability": "https://schema.org/InStock",
    "itemCondition": "https://schema.org/NewCondition",
    "seller": { "@id": "https://example.com/#organization" },
    "shippingDetails": {
      "@type": "OfferShippingDetails",
      "shippingRate": {
        "@type": "MonetaryAmount",
        "value": "0",
        "currency": "USD"
      },
      "deliveryTime": {
        "@type": "ShippingDeliveryTime",
        "handlingTime": {
          "@type": "QuantitativeValue",
          "minValue": 0,
          "maxValue": 1,
          "unitCode": "DAY"
        },
        "transitTime": {
          "@type": "QuantitativeValue",
          "minValue": 3,
          "maxValue": 7,
          "unitCode": "DAY"
        }
      },
      "shippingDestination": {
        "@type": "DefinedRegion",
        "addressCountry": "US"
      }
    },
    "hasMerchantReturnPolicy": {
      "@type": "MerchantReturnPolicy",
      "applicableCountry": "US",
      "returnPolicyCategory": "https://schema.org/MerchantReturnFiniteReturnWindow",
      "merchantReturnDays": 30,
      "returnMethod": "https://schema.org/ReturnByMail",
      "returnFees": "https://schema.org/FreeReturn"
    }
  },
  "aggregateRating": {
    "@type": "AggregateRating",
    "ratingValue": "4.7",
    "bestRating": "5",
    "ratingCount": "1823",
    "reviewCount": "312"
  },
  "review": [
    {
      "@type": "Review",
      "reviewRating": {
        "@type": "Rating",
        "ratingValue": "5",
        "bestRating": "5"
      },
      "author": {
        "@type": "Person",
        "name": "John D."
      },
      "reviewBody": "Excellent build quality and the smart features work flawlessly.",
      "datePublished": "2026-02-10"
    }
  ]
}
</script>
```

#### 3.5: FAQPage

```json
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "@id": "https://example.com/faq/#faqpage",
  "mainEntity": [
    {
      "@type": "Question",
      "name": "How long does shipping take?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Standard shipping takes 3-7 business days within the US. Express shipping (1-2 business days) is available for an additional $12.99. International shipping takes 10-21 business days depending on the destination."
      }
    },
    {
      "@type": "Question",
      "name": "What is your return policy?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "We offer a 30-day money-back guarantee on all products. Items must be in original packaging and unused condition. Contact support@example.com to initiate a return. Refunds are processed within 5-7 business days."
      }
    },
    {
      "@type": "Question",
      "name": "Do you offer bulk pricing?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Yes, we offer tiered pricing for orders of 10+ units. Contact our sales team at sales@example.com for a custom quote. Volume discounts range from 10% to 35% depending on quantity."
      }
    }
  ]
}
</script>
```

**Important:** Google's FAQ rich result guidelines require that FAQ content must be visible on the page. Do not add FAQ schema for content that users cannot see — this violates Google's structured data policies and may result in a manual action.

#### 3.6: HowTo

```json
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "HowTo",
  "@id": "https://example.com/guides/change-tire/#howto",
  "name": "How to Change a Flat Tire",
  "description": "Step-by-step instructions for safely changing a flat tire on the side of the road.",
  "image": "https://example.com/images/change-tire-hero.jpg",
  "totalTime": "PT30M",
  "estimatedCost": {
    "@type": "MonetaryAmount",
    "currency": "USD",
    "value": "0"
  },
  "supply": [
    { "@type": "HowToSupply", "name": "Spare tire" },
    { "@type": "HowToSupply", "name": "Wheel wedges" }
  ],
  "tool": [
    { "@type": "HowToTool", "name": "Car jack" },
    { "@type": "HowToTool", "name": "Lug wrench" },
    { "@type": "HowToTool", "name": "Flashlight" }
  ],
  "step": [
    {
      "@type": "HowToStep",
      "name": "Pull over safely",
      "text": "Move your car to a flat, stable surface away from traffic. Turn on your hazard lights and apply the parking brake.",
      "image": "https://example.com/images/step1-pullover.jpg",
      "url": "https://example.com/guides/change-tire/#step1"
    },
    {
      "@type": "HowToStep",
      "name": "Loosen the lug nuts",
      "text": "Using the lug wrench, turn each lug nut counterclockwise about half a turn. Do not remove them completely yet.",
      "image": "https://example.com/images/step2-loosen.jpg",
      "url": "https://example.com/guides/change-tire/#step2"
    },
    {
      "@type": "HowToStep",
      "name": "Jack up the vehicle",
      "text": "Place the jack under the vehicle frame near the flat tire. Raise the vehicle until the flat tire is about 6 inches off the ground.",
      "image": "https://example.com/images/step3-jack.jpg",
      "url": "https://example.com/guides/change-tire/#step3"
    },
    {
      "@type": "HowToStep",
      "name": "Replace the tire",
      "text": "Remove the lug nuts completely and pull off the flat tire. Mount the spare tire and hand-tighten the lug nuts in a star pattern.",
      "image": "https://example.com/images/step4-replace.jpg",
      "url": "https://example.com/guides/change-tire/#step4"
    },
    {
      "@type": "HowToStep",
      "name": "Lower and tighten",
      "text": "Lower the vehicle back to the ground. Tighten lug nuts fully in a star pattern using the lug wrench. Check tire pressure on the spare.",
      "image": "https://example.com/images/step5-lower.jpg",
      "url": "https://example.com/guides/change-tire/#step5"
    }
  ]
}
</script>
```

#### 3.7: Recipe

```json
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "Recipe",
  "@id": "https://example.com/recipes/chocolate-cake/#recipe",
  "name": "Classic Chocolate Layer Cake",
  "image": [
    "https://example.com/images/chocolate-cake-1x1.jpg",
    "https://example.com/images/chocolate-cake-4x3.jpg",
    "https://example.com/images/chocolate-cake-16x9.jpg"
  ],
  "author": {
    "@type": "Person",
    "name": "Chef Maria"
  },
  "datePublished": "2026-02-14",
  "description": "Rich, moist chocolate layer cake with dark chocolate ganache frosting. A foolproof recipe that's been perfected over 20 years.",
  "recipeCuisine": "American",
  "recipeCategory": "Dessert",
  "keywords": "chocolate cake, layer cake, birthday cake, chocolate ganache",
  "prepTime": "PT25M",
  "cookTime": "PT35M",
  "totalTime": "PT1H",
  "recipeYield": "12 servings",
  "nutrition": {
    "@type": "NutritionInformation",
    "calories": "420 calories",
    "fatContent": "22g",
    "carbohydrateContent": "54g",
    "proteinContent": "6g",
    "sugarContent": "38g"
  },
  "recipeIngredient": [
    "2 cups all-purpose flour",
    "2 cups granulated sugar",
    "3/4 cup unsweetened cocoa powder",
    "2 teaspoons baking soda",
    "1 teaspoon salt",
    "2 large eggs",
    "1 cup buttermilk",
    "1 cup hot water",
    "1/2 cup vegetable oil",
    "2 teaspoons vanilla extract"
  ],
  "recipeInstructions": [
    {
      "@type": "HowToStep",
      "text": "Preheat oven to 350°F (175°C). Grease and flour two 9-inch round cake pans."
    },
    {
      "@type": "HowToStep",
      "text": "In a large bowl, whisk together flour, sugar, cocoa powder, baking soda, and salt."
    },
    {
      "@type": "HowToStep",
      "text": "Add eggs, buttermilk, oil, and vanilla. Beat on medium speed for 2 minutes."
    },
    {
      "@type": "HowToStep",
      "text": "Stir in hot water (batter will be thin). Pour evenly into prepared pans."
    },
    {
      "@type": "HowToStep",
      "text": "Bake for 30-35 minutes until a toothpick inserted in the center comes out clean. Cool in pans for 10 minutes, then turn out onto wire racks."
    }
  ],
  "aggregateRating": {
    "@type": "AggregateRating",
    "ratingValue": "4.9",
    "ratingCount": "1547"
  },
  "video": {
    "@type": "VideoObject",
    "name": "How to Make Classic Chocolate Layer Cake",
    "description": "Watch Chef Maria demonstrate the complete chocolate cake recipe step by step.",
    "thumbnailUrl": "https://example.com/images/chocolate-cake-video-thumb.jpg",
    "contentUrl": "https://example.com/videos/chocolate-cake.mp4",
    "uploadDate": "2026-02-14",
    "duration": "PT8M30S"
  }
}
</script>
```

#### 3.8: Event

```json
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "Event",
  "@id": "https://example.com/events/tech-conference-2026/#event",
  "name": "TechForward 2026 Conference",
  "description": "The premier technology conference featuring keynotes from industry leaders, hands-on workshops, and networking sessions.",
  "image": "https://example.com/images/techforward-2026-banner.jpg",
  "startDate": "2026-09-15T09:00:00-05:00",
  "endDate": "2026-09-17T18:00:00-05:00",
  "eventStatus": "https://schema.org/EventScheduled",
  "eventAttendanceMode": "https://schema.org/OfflineEventAttendanceMode",
  "location": {
    "@type": "Place",
    "name": "Austin Convention Center",
    "address": {
      "@type": "PostalAddress",
      "streetAddress": "500 E Cesar Chavez St",
      "addressLocality": "Austin",
      "addressRegion": "TX",
      "postalCode": "78701",
      "addressCountry": "US"
    }
  },
  "performer": [
    {
      "@type": "Person",
      "name": "Dr. Sarah Chen",
      "jobTitle": "CTO, FutureTech Inc."
    }
  ],
  "organizer": {
    "@type": "Organization",
    "name": "TechForward Events",
    "url": "https://techforward.events"
  },
  "offers": [
    {
      "@type": "Offer",
      "name": "Early Bird",
      "price": "499.00",
      "priceCurrency": "USD",
      "availability": "https://schema.org/InStock",
      "validFrom": "2026-03-01",
      "url": "https://example.com/events/tech-conference-2026/tickets"
    },
    {
      "@type": "Offer",
      "name": "General Admission",
      "price": "799.00",
      "priceCurrency": "USD",
      "availability": "https://schema.org/InStock",
      "validFrom": "2026-06-01",
      "url": "https://example.com/events/tech-conference-2026/tickets"
    }
  ]
}
</script>
```

#### 3.9: BreadcrumbList

```json
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "BreadcrumbList",
  "itemListElement": [
    {
      "@type": "ListItem",
      "position": 1,
      "name": "Home",
      "item": "https://example.com/"
    },
    {
      "@type": "ListItem",
      "position": 2,
      "name": "Blog",
      "item": "https://example.com/blog/"
    },
    {
      "@type": "ListItem",
      "position": 3,
      "name": "SEO Guide",
      "item": "https://example.com/blog/seo-guide/"
    }
  ]
}
</script>
```

**BreadcrumbList is the universal schema type.** Add it to every page on the site. It replaces the raw URL in search results with a readable breadcrumb trail. Low effort, high visual impact, zero risk.

#### 3.10: VideoObject

```json
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "VideoObject",
  "@id": "https://example.com/videos/product-demo/#video",
  "name": "Widget Pro 3000 — Full Product Demo",
  "description": "Watch a complete walkthrough of the Widget Pro 3000 features, setup process, and real-world use cases.",
  "thumbnailUrl": "https://example.com/images/demo-thumbnail.jpg",
  "uploadDate": "2026-03-01",
  "duration": "PT12M45S",
  "contentUrl": "https://example.com/videos/product-demo.mp4",
  "embedUrl": "https://www.youtube.com/embed/abc123def",
  "interactionStatistic": {
    "@type": "InteractionCounter",
    "interactionType": { "@type": "WatchAction" },
    "userInteractionCount": 48230
  },
  "publisher": { "@id": "https://example.com/#organization" }
}
</script>
```

#### Advanced: @graph and @id Cross-Referencing

When a page has multiple schema types, use the `@graph` pattern to bundle them in a single `<script>` tag with `@id` cross-references. This tells Google how entities relate to each other.

```json
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@graph": [
    {
      "@type": "Organization",
      "@id": "https://example.com/#organization",
      "name": "Example Company",
      "url": "https://example.com",
      "logo": {
        "@type": "ImageObject",
        "@id": "https://example.com/#logo",
        "url": "https://example.com/logo.png"
      }
    },
    {
      "@type": "WebSite",
      "@id": "https://example.com/#website",
      "url": "https://example.com",
      "name": "Example Company",
      "publisher": { "@id": "https://example.com/#organization" }
    },
    {
      "@type": "WebPage",
      "@id": "https://example.com/blog/seo-guide/#webpage",
      "url": "https://example.com/blog/seo-guide/",
      "name": "SEO Guide",
      "isPartOf": { "@id": "https://example.com/#website" },
      "breadcrumb": { "@id": "https://example.com/blog/seo-guide/#breadcrumb" }
    },
    {
      "@type": "BreadcrumbList",
      "@id": "https://example.com/blog/seo-guide/#breadcrumb",
      "itemListElement": [
        { "@type": "ListItem", "position": 1, "name": "Home", "item": "https://example.com/" },
        { "@type": "ListItem", "position": 2, "name": "Blog", "item": "https://example.com/blog/" },
        { "@type": "ListItem", "position": 3, "name": "SEO Guide" }
      ]
    },
    {
      "@type": "Article",
      "@id": "https://example.com/blog/seo-guide/#article",
      "headline": "The Complete Guide to SEO in 2026",
      "isPartOf": { "@id": "https://example.com/blog/seo-guide/#webpage" },
      "author": { "@id": "https://example.com/#author-jane" },
      "publisher": { "@id": "https://example.com/#organization" },
      "datePublished": "2026-01-15",
      "dateModified": "2026-03-20",
      "image": { "@id": "https://example.com/blog/seo-guide/#primaryimage" }
    },
    {
      "@type": "Person",
      "@id": "https://example.com/#author-jane",
      "name": "Jane Smith",
      "url": "https://example.com/about/jane-smith"
    },
    {
      "@type": "ImageObject",
      "@id": "https://example.com/blog/seo-guide/#primaryimage",
      "url": "https://example.com/images/seo-guide-hero.jpg",
      "width": 1200,
      "height": 630
    }
  ]
}
</script>
```

**@id naming convention:** Use the pattern `https://domain.com/page-path/#type` — for example, `/#organization`, `/blog/post-slug/#article`, `/products/sku/#product`. This creates globally unique identifiers that enable cross-page entity linking.

---

### Step 4: Rich Result Optimization

Not every schema type triggers a rich result. Focus implementation effort on types that produce visible SERP enhancements.

#### Rich Result Eligibility Matrix

| Schema Type | Google Rich Result | Visual Enhancement | Required Properties | Recommended Properties |
|-------------|-------------------|-------------------|---------------------|----------------------|
| **Article** | Article carousel | Author, date, image in SERP | `headline`, `image`, `datePublished`, `author` | `dateModified`, `publisher`, `description` |
| **FAQPage** | FAQ accordion | Expandable Q&A below listing | `mainEntity[]` with `Question` + `acceptedAnswer` | — |
| **HowTo** | How-to steps | Numbered steps, images, time | `name`, `step[]` with `HowToStep` | `image`, `totalTime`, `estimatedCost`, `supply`, `tool` |
| **Product** | Product snippet | Stars, price, availability | `name`, `offers` (with `price`, `priceCurrency`, `availability`), `review` or `aggregateRating` | `image`, `brand`, `sku`, `description`, `shippingDetails`, `returnPolicy` |
| **Recipe** | Recipe card | Image, time, rating, calories | `name`, `image`, `recipeIngredient`, `recipeInstructions` | `aggregateRating`, `nutrition`, `prepTime`, `cookTime`, `recipeYield`, `video` |
| **Event** | Event listing | Date, location, price range | `name`, `startDate`, `location` | `endDate`, `offers`, `eventStatus`, `eventAttendanceMode`, `performer`, `organizer`, `image` |
| **VideoObject** | Video carousel | Thumbnail, duration, upload date | `name`, `thumbnailUrl`, `uploadDate` | `description`, `duration`, `contentUrl`, `embedUrl` |
| **LocalBusiness** | Local pack / knowledge panel | Map, hours, phone, rating | `name`, `address` | `telephone`, `openingHoursSpecification`, `geo`, `aggregateRating`, `priceRange` |
| **BreadcrumbList** | Breadcrumb trail | URL replaced with breadcrumbs | `itemListElement[]` with `ListItem` (position, name) | `item` (URL for each crumb except the last) |
| **JobPosting** | Google for Jobs | Salary, location, post date | `title`, `description`, `datePosted`, `hiringOrganization`, `jobLocation` | `baseSalary`, `employmentType`, `validThrough`, `applicantLocationRequirements` |
| **Course** | Course listing | Provider, description | `name`, `description`, `provider` | `offers`, `coursePrerequisites`, `hasCourseInstance` |
| **SoftwareApplication** | Software snippet | Stars, price, OS | `name`, `offers` or `aggregateRating` | `operatingSystem`, `applicationCategory`, `downloadUrl` |
| **WebSite + SearchAction** | Sitelinks search box | Search box in knowledge panel | `potentialAction` with `SearchAction` + `query-input` | — |

#### Properties Hierarchy: Required vs Recommended

Google distinguishes between properties that are **required** (schema will fail validation without them) and **recommended** (improve rich result quality and eligibility).

**Rule of thumb:** Always include ALL required properties. Then include as many recommended properties as the page's real content supports. Never fabricate data to fill optional fields — Google penalizes misleading structured data.

#### Rich Results That Google Has Deprecated or Restricted

Be aware of changes to avoid wasted effort:

- **FAQ rich results**: As of August 2023, Google restricted FAQ rich results to well-known, authoritative government and health websites. Most sites will NOT see FAQ accordions in search results even with valid FAQPage schema. The schema is still valid and may be used by other search engines, but do not promise Google FAQ rich results to clients.
- **HowTo rich results**: As of August 2023, Google removed HowTo rich results from mobile search and significantly reduced them on desktop. The schema is still valid but visual impact is diminished.
- **Review snippet self-serving restrictions**: Review/AggregateRating on your own business (e.g., a restaurant rating itself) will not produce rich results. Reviews must be about a named item (product, book, recipe, etc.), not the business itself.

**Always communicate these restrictions to the user.** Structured data still benefits knowledge graph understanding and other search engines (Bing, Yandex, etc.) even when Google does not render a visible rich result.

---

### Step 5: Validation & Testing

Every JSON-LD block must be validated before deployment. Invalid schema wastes effort and may trigger Search Console warnings.

#### 5a: Validation Tools

| Tool | URL | Purpose |
|------|-----|---------|
| **Google Rich Results Test** | https://search.google.com/test/rich-results | Tests if a URL or code snippet is eligible for Google rich results. Shows which rich result types are detected and any errors/warnings. |
| **Schema Markup Validator** | https://validator.schema.org/ | Validates any schema.org markup against the full vocabulary. More comprehensive than Google's tool but does not indicate rich result eligibility. |
| **Google Search Console** | https://search.google.com/search-console | Shows structured data errors/warnings across the entire site, rich result performance, and indexing status. |

#### 5b: Testing Workflow

1. **Write the JSON-LD** for the target page
2. **Validate the code snippet** using Google Rich Results Test (paste the raw JSON-LD, not the URL — this lets you test before deployment)
3. **Fix all errors** — errors prevent rich results entirely
4. **Address warnings** — warnings reduce eligibility but do not block rich results
5. **Deploy the schema** to the live page
6. **Test the live URL** using Google Rich Results Test (catches server-side rendering issues)
7. **Request indexing** via Google Search Console URL Inspection
8. **Monitor** the Enhancements section in Search Console for the specific rich result type

#### 5c: Common Validation Errors and Fixes

| Error | Cause | Fix |
|-------|-------|-----|
| `Missing field "image"` | Article/Recipe missing required image | Add `"image"` with a valid URL, min 1200px wide for Article |
| `Missing field "author"` | Article without author information | Add `"author"` with `@type: Person` and `name` |
| `Invalid URL in "item"` | BreadcrumbList item is not a valid absolute URL | Use full `https://` URLs, not relative paths |
| `Price not found` | Product Offer missing price or priceCurrency | Add both `"price"` and `"priceCurrency"` to the Offer |
| `Missing field "name"` | Any schema type missing the name property | Add `"name"` — it is required on virtually every type |
| `Invalid ISO 8601 date` | Date format is wrong (e.g., "March 15, 2026") | Use `"2026-03-15"` or `"2026-03-15T09:00:00-05:00"` |
| `Review has no reviewed item` | Review schema not nested inside a Product/LocalBusiness | Nest Review inside its parent item, or use `"itemReviewed"` |
| `Duplicate @id` | Two entities share the same @id | Ensure every @id is globally unique using the URL+fragment pattern |
| `Self-serving review` | Business reviewing itself | Move review to a specific product/service, not the Organization |
| `Multiple entities of same type` | Two conflicting Organization schemas on one page | Consolidate into one using @graph and @id references |

#### 5d: Automated Testing Script

For sites with many pages, use a programmatic validation workflow:

```bash
# Fetch schema from a live URL and validate structure
curl -s "https://example.com/page" | \
  python3 -c "
import sys, json, re
html = sys.stdin.read()
scripts = re.findall(r'<script[^>]*application/ld\+json[^>]*>(.*?)</script>', html, re.DOTALL)
for i, s in enumerate(scripts):
    try:
        data = json.loads(s)
        print(f'Schema {i+1}: VALID JSON')
        if '@type' in data:
            print(f'  Type: {data[\"@type\"]}')
        elif '@graph' in data:
            types = [e.get('@type', 'Unknown') for e in data['@graph']]
            print(f'  Graph types: {types}')
    except json.JSONDecodeError as e:
        print(f'Schema {i+1}: INVALID JSON - {e}')
"
```

---

### Step 6: CMS Implementation

Schema markup injection varies by platform. Use the appropriate method for the user's tech stack.

#### 6a: WordPress — Yoast SEO

Yoast automatically generates Organization, WebSite, Article, and BreadcrumbList schema. To customize or add types Yoast does not support:

```php
// functions.php — Add custom schema to specific pages
add_action('wp_head', function() {
    if (is_page('faq')) {
        ?>
        <script type="application/ld+json">
        {
            "@context": "https://schema.org",
            "@type": "FAQPage",
            "mainEntity": [
                {
                    "@type": "Question",
                    "name": "Your question here?",
                    "acceptedAnswer": {
                        "@type": "Answer",
                        "text": "Your answer here."
                    }
                }
            ]
        }
        </script>
        <?php
    }
});
```

**Yoast Schema API (preferred over raw injection):**

```php
// Modify Yoast's schema output via filter
add_filter('wpseo_schema_graph_pieces', function($pieces, $context) {
    $pieces[] = new My_Custom_Schema_Piece($context);
    return $pieces;
}, 10, 2);
```

#### 6b: WordPress — Rank Math

Rank Math has built-in support for 20+ schema types via its Schema Generator in the post editor. For types not covered by the UI:

```php
// Add custom schema via Rank Math filter
add_filter('rank_math/json_ld', function($data, $jsonld) {
    if (is_singular('product')) {
        // Modify or add to existing Product schema
        if (isset($data['ProductPage'])) {
            $data['ProductPage']['brand'] = [
                '@type' => 'Brand',
                'name' => 'Your Brand'
            ];
        }
    }
    return $data;
}, 10, 2);
```

#### 6c: Shopify

Shopify themes include basic Product and BreadcrumbList schema in `product.liquid`. To add or override:

```liquid
{%- comment -%} Add to theme.liquid or a snippet {%- endcomment -%}

{%- if template == 'index' -%}
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "Organization",
  "name": "{{ shop.name | escape }}",
  "url": "{{ shop.url }}",
  "logo": "{{ shop.logo | img_url: 'master' }}",
  "contactPoint": {
    "@type": "ContactPoint",
    "telephone": "{{ shop.phone | escape }}",
    "contactType": "customer service"
  },
  "sameAs": [
    "{{ settings.social_facebook_link }}",
    "{{ settings.social_twitter_link }}",
    "{{ settings.social_instagram_link }}"
  ]
}
</script>
{%- endif -%}

{%- if template contains 'product' -%}
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "Product",
  "name": "{{ product.title | escape }}",
  "image": "{{ product.featured_image | img_url: 'grande' }}",
  "description": "{{ product.description | strip_html | truncate: 200 | escape }}",
  "sku": "{{ product.selected_or_first_available_variant.sku | escape }}",
  "brand": {
    "@type": "Brand",
    "name": "{{ product.vendor | escape }}"
  },
  "offers": {
    "@type": "Offer",
    "url": "{{ shop.url }}{{ product.url }}",
    "priceCurrency": "{{ cart.currency.iso_code }}",
    "price": "{{ product.selected_or_first_available_variant.price | money_without_currency | remove: ',' }}",
    "availability": "{% if product.available %}https://schema.org/InStock{% else %}https://schema.org/OutOfStock{% endif %}",
    "itemCondition": "https://schema.org/NewCondition"
  }
}
</script>
{%- endif -%}
```

**Important for Shopify:** Check if the active theme already injects Product schema. Duplicate Product schemas on the same page cause validation warnings. Remove the theme's built-in schema before adding custom markup.

#### 6d: Next.js / React

Use the `next/head` component or the App Router `metadata` API:

```tsx
// app/blog/[slug]/page.tsx (App Router)
import { Metadata } from 'next';

// Generate structured data for each post
function generateArticleSchema(post: Post) {
  return {
    '@context': 'https://schema.org',
    '@type': 'Article',
    headline: post.title,
    description: post.excerpt,
    image: post.coverImage,
    datePublished: post.publishedAt,
    dateModified: post.updatedAt,
    author: {
      '@type': 'Person',
      name: post.author.name,
      url: post.author.url,
    },
    publisher: {
      '@type': 'Organization',
      name: 'Example Company',
      logo: {
        '@type': 'ImageObject',
        url: 'https://example.com/logo.png',
      },
    },
  };
}

export default function BlogPost({ params }: { params: { slug: string } }) {
  const post = getPost(params.slug);

  return (
    <>
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{
          __html: JSON.stringify(generateArticleSchema(post)),
        }}
      />
      <article>{/* ... post content ... */}</article>
    </>
  );
}
```

**For site-wide schema (Organization, WebSite):** Add to the root layout component so it appears on every page.

#### 6e: Static HTML

For static sites without a CMS, add JSON-LD directly in the `<head>`:

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Page Title</title>

    <!-- Structured Data -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "Article",
        "headline": "Article Title",
        "author": { "@type": "Person", "name": "Author Name" },
        "datePublished": "2026-03-15"
    }
    </script>
</head>
<body>
    <!-- Page content -->
</body>
</html>
```

**For static site generators** (Hugo, Jekyll, Eleventy): Create a partial/include template that generates JSON-LD from front matter variables and include it in the base layout.

#### 6f: Custom CMS / Server-Rendered

For custom backends, build a schema helper that generates JSON-LD from page data:

```python
# Python / Django / Flask example
import json
from datetime import datetime

def generate_schema(page_type, data):
    """Generate JSON-LD structured data from page data."""
    schemas = {
        'article': {
            '@context': 'https://schema.org',
            '@type': 'Article',
            'headline': data.get('title'),
            'description': data.get('description'),
            'author': {'@type': 'Person', 'name': data.get('author')},
            'datePublished': data.get('published_at', datetime.now().isoformat()),
            'dateModified': data.get('updated_at'),
            'image': data.get('image_url'),
            'publisher': {
                '@type': 'Organization',
                '@id': f"{data.get('site_url', '')}/#organization"
            }
        },
        'product': {
            '@context': 'https://schema.org',
            '@type': 'Product',
            'name': data.get('name'),
            'description': data.get('description'),
            'image': data.get('image_url'),
            'sku': data.get('sku'),
            'brand': {'@type': 'Brand', 'name': data.get('brand')},
            'offers': {
                '@type': 'Offer',
                'price': str(data.get('price', 0)),
                'priceCurrency': data.get('currency', 'USD'),
                'availability': f"https://schema.org/{'InStock' if data.get('in_stock') else 'OutOfStock'}"
            }
        }
    }
    schema = schemas.get(page_type, {})
    # Remove None values
    schema = {k: v for k, v in schema.items() if v is not None}
    return f'<script type="application/ld+json">\n{json.dumps(schema, indent=2)}\n</script>'
```

---

### Step 7: Monitoring & Maintenance

Schema markup is not set-and-forget. Search engines update their requirements, pages change, and schema can drift out of sync with visible content.

#### 7a: Google Search Console Monitoring

Check these reports monthly:

| Report | Location in GSC | What to Monitor |
|--------|----------------|-----------------|
| **Rich result status** | Enhancements section (per type) | Valid items, items with warnings, invalid items |
| **Manual actions** | Security & Manual Actions | Any penalties related to structured data spam |
| **URL inspection** | URL Inspection tool | Per-URL schema detection and validity |
| **Performance by rich result** | Performance > Search Appearance filter | Click-through rate for pages with rich results vs without |

#### 7b: Performance Tracking

Track these metrics before and after schema implementation:

- **Click-through rate (CTR)**: Compare CTR for pages with rich results vs baseline. Typical improvement: 10-30% CTR lift.
- **Impressions**: Rich results may increase impressions by making results more visible.
- **Rich result visibility**: Use the Performance report filtered by Search Appearance to isolate rich result traffic.
- **Conversion rate from organic**: If CTR improves but conversion drops, schema may be setting wrong expectations.

#### 7c: Schema Drift Detection

Schema drifts when page content changes but structured data stays the same. Common drift scenarios:

| Drift Type | Example | Detection |
|------------|---------|-----------|
| **Price drift** | Product price changed but schema still shows old price | Compare schema `price` to visible page price |
| **Availability drift** | Product went out of stock but schema says InStock | Compare `availability` to actual stock status |
| **Date drift** | Article was updated but `dateModified` was not | Compare `dateModified` to actual last-modified date |
| **Author drift** | Author byline changed but schema still references old author | Compare `author.name` to visible byline |
| **Rating drift** | New reviews came in but `aggregateRating` is stale | Compare `ratingValue` / `reviewCount` to live data |
| **Content mismatch** | FAQ schema lists questions not on the visible page | Verify every FAQ `Question.name` appears in visible content |

**For dynamic sites**, ensure schema is generated from the same data source as the visible page — never hardcode schema values when the underlying data changes.

#### 7d: Ongoing Maintenance Checklist

Run this quarterly:

- [ ] **Re-validate** all schema types using Google Rich Results Test
- [ ] **Check Search Console** for new errors or warnings in Enhancements
- [ ] **Review Google's documentation** for schema type changes (deprecations, new required fields)
- [ ] **Audit content-schema sync** — spot-check 5-10 pages for drift
- [ ] **Check competitor SERP features** — are they showing rich results you are not?
- [ ] **Review new schema types** — Google periodically supports new rich results (check https://developers.google.com/search/docs/appearance/structured-data/search-gallery)

---

### Step 8: Output

Deliver the following to the user:

1. **Complete JSON-LD blocks** — ready to copy-paste into `<head>` or CMS, customized with the user's actual data (business name, URLs, product details, etc.)
2. **Implementation instructions** — specific to their CMS/tech stack (from Step 6)
3. **Validation results** — confirmation that each block passes Google Rich Results Test, with any warnings noted
4. **Rich result eligibility summary** — which rich results each schema type targets, with honest notes about which ones Google currently displays vs restricts
5. **Priority ranking** — if the user has many page types, rank which schemas to implement first by impact:
   - **Tier 1 (implement immediately):** BreadcrumbList (all pages), Organization/WebSite (homepage), Product (if e-commerce)
   - **Tier 2 (high impact):** Article (blog), LocalBusiness (local businesses), Recipe (food sites), Event (event sites)
   - **Tier 3 (moderate impact):** VideoObject, Course, SoftwareApplication, JobPosting
   - **Tier 4 (supplementary):** FAQPage, HowTo (reduced Google visibility since 2023, but still useful for other engines)

---

## Anti-Patterns

These are common mistakes that waste effort, trigger penalties, or produce no results. Flag any of these in existing markup.

| Anti-Pattern | Why It Fails | Fix |
|--------------|-------------|-----|
| **Invisible content schema** | FAQ/HowTo schema for content not visible on the page — violates Google's guidelines | Only mark up content that users can see and interact with |
| **Self-serving reviews** | Business adding AggregateRating about itself (not a specific product) | Attach ratings to named products/services, not the Organization |
| **Hardcoded schema on dynamic pages** | Price, availability, or ratings hardcoded while page data changes | Generate schema server-side from the same data source as the page |
| **Duplicate schema types** | Two competing Organization or Product blocks on one page | Consolidate using @graph with @id references |
| **Missing required properties** | Schema passes JSON validation but fails rich result requirements | Always cross-check against Google's required property list |
| **Fabricated data** | Adding fake reviews, ratings, or prices to trigger rich results | Only use real, verifiable data — Google penalizes with manual actions |
| **Schema on every page without relevance** | Adding Product schema to the About page | Match schema types to actual page content |
| **Using Microdata or RDFa** | Mixing formats or using older formats alongside JSON-LD | Standardize on JSON-LD for all structured data |
| **Orphaned @id references** | Referencing an @id that does not exist in the @graph | Ensure every `{ "@id": "..." }` reference has a matching entity definition |
| **Over-nesting** | Deeply nesting 5+ levels of schema objects | Use @id references to flatten the graph; keep individual entities at the @graph root level |
| **Ignoring dateModified** | Article schema with datePublished but no dateModified | Always include dateModified — Google uses it for freshness signals |

---

## Escalation

Escalate to manual review or a specialist when:

| Scenario | Action |
|----------|--------|
| **Manual action for structured data spam** | Review Google Search Console manual action details. Remove violating schema. Submit reconsideration request. |
| **Schema requires server-side dynamic generation** | If the user's CMS cannot inject JSON-LD dynamically, recommend a developer or plugin solution — do not suggest client-side JS injection as it is unreliable for Googlebot. |
| **Complex multi-location schema** | Businesses with 10+ locations need a scalable LocalBusiness schema strategy — recommend a structured data plugin or API-driven approach. |
| **E-commerce with thousands of products** | Manually writing schema per product is not feasible — recommend Yoast/Rank Math WooCommerce integration, Shopify's built-in schema, or a custom product feed to JSON-LD pipeline. |
| **Knowledge panel disputes** | If Organization schema does not produce a knowledge panel, or produces the wrong one — this requires Google Business Profile verification and entity reconciliation, beyond schema markup alone. |
| **Schema for unsupported rich result types** | If the user requests a rich result that Google does not support via structured data (e.g., featured snippets are not triggered by schema) — set expectations and explain the actual ranking factor. |

---

## Inputs

| Input | Required | Description |
|-------|----------|-------------|
| Website URL | Yes | The site receiving structured data |
| Page types | Yes | Which pages need schema markup |
| Business type | No | Organization category for type selection |
| Current schema status | No | Existing markup and known errors |
| Target rich results | No | Desired SERP enhancements |
| CMS / tech stack | No | Platform for implementation instructions |
| Business details | No | Name, address, phone, logo, social profiles |
| Product details | No | Price, SKU, brand, availability, reviews |

## Outputs

| Output | Format | Description |
|--------|--------|-------------|
| JSON-LD blocks | Code (JSON) | Complete, valid structured data ready for implementation |
| Implementation guide | Markdown | CMS-specific instructions for deploying the schema |
| Validation report | Table | Pass/fail status for each schema block with error details |
| Rich result eligibility | Table | Which rich results each schema type targets and current Google support status |
| Priority roadmap | Ranked list | Which schemas to implement first based on impact |
| Monitoring plan | Checklist | Ongoing validation and drift detection schedule |

---

## Level History

- **Lv.1** — Base: Schema type selection, JSON-LD format guidance, basic validation workflow, CMS injection patterns. (Origin: MemStack v2.0, Feb 2026)
- **Lv.2** — Production: Added 10 complete JSON-LD examples, @graph/@id cross-referencing, rich result eligibility matrix with required/recommended properties, Google FAQ/HowTo deprecation notes, common validation errors table, CMS-specific implementation for WordPress/Shopify/Next.js/static/custom, automated testing script, schema drift detection, quarterly maintenance checklist, anti-patterns, escalation paths. (Origin: MemStack v3.2, Mar 2026)
