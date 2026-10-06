# Make the MCP easier for agents to discover

Type: grilling
Status: claimed

## Question

How should Brain's MCP tools and documentation signal to agents when Brain is an appropriate tool, what each tool can do, and how to choose among its capabilities? Identify where discoverability currently breaks down (tool names and descriptions, server instructions, setup guidance, or examples), and define a small set of representative agent tasks that should reliably lead to Brain use.

## Comments

- Claimed for implementation. MCP server instructions and tool descriptions now explain when Brain is useful, how to browse/search/open content, that MCP search covers generated Pages only, and when full content may be large. Added `docs/mcp-agent-guide.md` with representative tasks and linked it from the README. The trace description documents that local traces discard caller correlation IDs. Focused `internal/mcpserver` tests pass; the full ordinary suite was attempted but hit unrelated intermittent Windows rename failures after the sandbox rerun.
