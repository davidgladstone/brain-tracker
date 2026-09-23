# 02: Honor configured classification retries

**What to build:** Operators' configured retry limit controls how many bounded retries the classification worker makes after transient provider failures, without changing the meaning of a valid abstention.

**Blocked by:** None (can start immediately).

**Status:** resolved

- [x] The production classification request receives the configured retry count.
- [x] Zero retries makes exactly one provider attempt; a positive configured limit permits no more than that many retries.
- [x] Successful retry provenance reports the number of retries, and exhausted failures remain retryable worker failures.
- [x] Tests cover configuration-to-worker propagation and retry bounds.

## Comments

- Wired the configured `max_retries` from daemon startup through the classification worker into each bounded LLM request. Worker/runtime tests cover propagation, retry count, and zero-retry behavior.
- Application commit: `c0ccae2`.
