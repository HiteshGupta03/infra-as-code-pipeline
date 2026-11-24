const assert = require("node:assert/strict");
const test = require("node:test");

const { getJwtSecret } = require("../config");

// Test 1: Accept a valid JWT secret
test("accepts a valid JWT secret", () => {
  const secret = "a".repeat(32);

  assert.equal(getJwtSecret(secret), secret);
});

// Test 2: Trim whitespace
test("trims whitespace from JWT secret", () => {
  const secret = "a".repeat(32);

  assert.equal(getJwtSecret(` ${secret} `), secret);
});

// Test 3: Reject missing or invalid values
test("rejects missing or invalid JWT secrets", () => {
  const invalidValues = [
    undefined,
    null,
    "",
    "   ",
    123
  ];

  for (const value of invalidValues) {
    assert.throws(() => getJwtSecret(value));
  }
});

// Test 4: Reject sample JWT secret
test("rejects the sample JWT secret", () => {
  assert.throws(
    () => getJwtSecret("your_jwt_secret_key_here"),
    /must be a unique/
  );
});

// Test 5: Reject short JWT secrets
test("rejects JWT secrets shorter than 32 characters", () => {
  assert.throws(
    () => getJwtSecret("short-secret"),
    /at least 32 characters/
  );
});