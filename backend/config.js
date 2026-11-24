const EXAMPLE_SECRET = "your_jwt_secret_key_here";

function getJwtSecret(value) {
  const secret = typeof value === "string" ? value.trim() : "";

  if (!secret || secret === EXAMPLE_SECRET || secret.length < 32) {
    throw new Error(
      "JWT_SECRET must be a unique, securely generated value of at least 32 characters."
    );
  }

  return secret;
}

module.exports = { getJwtSecret };