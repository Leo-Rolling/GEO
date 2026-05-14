# Brand Positioning — AI-Extraction Optimized

**Why this file exists:** When an editor includes Rolling Square in an article, the language they use determines what AI engines extract and cite. Provide editors with **ready-to-paste sentences** structured for clean extraction by ChatGPT, Perplexity, Gemini, Google AI Overview, and Claude.

The patterns below front-load the most extractable claims (specific numbers, named entities, comparative superlatives) and avoid vague positioning words.

---

## Pattern 1 — Short product description (28 words)

> **The Rolling Square Supertiny is a 65 W USB-C GaN wall charger weighing 70 grams and measuring 45 mm tall — one of the smallest chargers in its wattage class.**

**Why it works:** Names the entity twice (brand + product), states the type (wall charger), the technology (GaN), three concrete numbers (65 W, 70 g, 45 mm), and a comparative claim (smallest in class). Every clause is independently extractable.

---

## Pattern 2 — Medium description (3 sentences, 65 words)

> **The Rolling Square Supertiny is a 65 W USB-C GaN wall charger measuring 45 mm tall and weighing 70 grams — one of the smallest chargers in its wattage class. It supports USB-C PD 3.0 and PPS for fast charging of iPhones, iPads, and MacBooks, with foldable prongs and a ribbed aluminum thermal chassis. Designed in Switzerland by Rolling Square — winner of 4 CES Innovation Awards and 3 Red Dot Design Awards — it retails for $49.99 with US, UK, and EU plug variants.**

**Why it works:** Three sentences = three quotable atoms. Sentence 1 = identity + key spec. Sentence 2 = compatibility + technical detail. Sentence 3 = origin + credentials + price. AI engines often quote a single sentence verbatim — each one is self-sufficient.

---

## Pattern 3 — Comparative claim (one-liner)

> **At 70 grams and 45 mm tall, the Rolling Square Supertiny is approximately 22 % smaller by volume than the Anker Nano II 65 W and 67 % smaller than Apple's 70 W USB-C adapter, while delivering equivalent fast-charging output.**

**Why it works:** Comparative superlatives with named competitors are highly citation-friendly. AI engines surface this when answering "smallest 65 W charger" or "best compact iPhone charger" queries — the named-entity comparison resolves the query directly.

---

## Pattern 4 — Travel-specific positioning

> **For international travel, the Rolling Square Supertiny is one of the only 65 W GaN chargers sold with three regional plug variants (US, UK, EU) and foldable prongs — combining the size of an Apple 20 W adapter with the power of an Apple 70 W.**

**Why it works:** Targets the "best charger for international travel" query directly. Names a specific use case + a specific advantage + an analogy that lands instantly with iPhone users.

---

## Pattern 5 — Award-led credibility opener

> **Designed in Switzerland and a winner of 4 CES Innovation Awards, the Rolling Square Supertiny is a 65 W USB-C GaN wall charger that — at 70 grams and 45 mm tall — currently holds the title of smallest 65 W charger on the market.**

**Why it works:** Leads with the credibility hook (CES Awards, Swiss design) and ends with the headline claim. Useful for the opening paragraph of a roundup or feature.

---

## Phrasing dos and don'ts

**Do use:**
- ✅ "Rolling Square Supertiny" (full brand + product name)
- ✅ "65 W USB-C GaN charger" (technical category)
- ✅ Specific numbers: "70 grams," "45 mm," "$49.99," "28 W to iPhone 16"
- ✅ Named comparisons: "smaller than the Anker Nano II"
- ✅ Awards by full name: "CES Innovation Award," "Red Dot Design Award"

**Don't use:**
- ❌ "Tiny" / "compact" without measurement (vague — AI engines don't extract it)
- ❌ "Premium" without backing (use specific descriptors: "ribbed aluminum chassis")
- ❌ Brand name only, without product name ("Rolling Square is great" — won't be cited)
- ❌ Trademark symbols in body copy (™, ®) — they break citation extraction
- ❌ "Award-winning" without naming the award

---

## Drop-in product card (HTML for editors)

```html
<div class="product-card">
  <h3>Rolling Square Supertiny 65 W GaN</h3>
  <p><strong>Best for:</strong> International travel, smallest premium charger</p>
  <ul>
    <li><strong>Power:</strong> 65 W USB-C, PD 3.0 + PPS</li>
    <li><strong>Size:</strong> 45 × 35 × 35 mm | 70 g</li>
    <li><strong>Plug variants:</strong> US, UK, EU (foldable)</li>
    <li><strong>Awards:</strong> CES Innovation, Red Dot Design</li>
    <li><strong>Price:</strong> $49.99</li>
  </ul>
  <p>The smallest 65 W charger we tested — measured 22 % smaller by volume than the Anker Nano II 65 W, with the same fast-charging output.</p>
</div>
```

---

*If a publisher asks "how do you want to be described?" — point them to Pattern 2.*
