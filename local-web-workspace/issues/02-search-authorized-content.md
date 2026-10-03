# 02: Search authorized content

**What to build:** A user searches the current Profile's available Areas, Pages, and Sources, filters the result types, and opens an authorized result without learning that hidden results exist.

**Blocked by:** 01 Browse authorized Publications locally.

**Status:** ready-for-agent

- [ ] Search can query Areas, Knowledge Variants, and Sources and filter results by those types.
- [ ] Search is scoped to the active Profile and currently permitted Audience Publications.
- [ ] Unauthorized names, snippets, counts, and source metadata do not appear in results or errors.
- [ ] Catalog search results are revalidated against current read authorization before response.
- [ ] HTTP integration tests cover matching, filtering, Profile changes, and unauthorized result suppression.
