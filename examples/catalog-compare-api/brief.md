# Take-home brief (fictional)

**Role:** Product / engineering lead take-home  
**Timebox:** about one working day  
**Language:** any  
**AI:** allowed and expected; say what you used

## Problem

Buyers at a mid-size retailer paste two catalog extracts: *ours* and a
supplier file. They need a structured diff, not a spreadsheet.

Build a small HTTP service that:

1. Upserts products into a named source (`ours`, `supplier-a`, …)
2. Fetches one product by source + SKU
3. Lists products in a source
4. Compares two sources and reports, per SKU:
   - `match`
   - `missing_left`
   - `missing_right`
   - `price_diff`
   - `field_diff`

A product has: `sku`, `name`, `price_cents`, `category`, `source`.

In-memory storage is acceptable. We will not deploy this.

## How we score (primary)

1. Error handling
2. Tests
3. Documentation

Secondary: structure, API taste, concurrency safety if you stay in-memory.

## Company context (also fictional)

Production services are Go and Java. Public docs are thin. There is no
published API style guide for candidates.
