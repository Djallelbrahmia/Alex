variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "eu-west-3"
}

variable "clerk_jwks_url" {
  description = "Clerk JWKS URL for JWT validation in Lambda"
  type        = string
}

variable "clerk_issuer" {
  description = "Clerk issuer URL (kept for Lambda environment)"
  type        = string
  default     = ""  # Not actually used but kept for backwards compatibility
}