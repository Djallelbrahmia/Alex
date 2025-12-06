variable "aws_region" {
  description = "AWS region for resources"
  type        = string
}

variable "openai_api_key" {
  description = "OpenAI API key for the researcher agent"
  type        = string
  sensitive   = true
}

variable "alex_api_endpoint" {
  description = "Alex API endpoint "
  type        = string
}

variable "alex_api_key" {
  description = "Alex API key "
  type        = string
  sensitive   = true
}

variable "scheduler_enabled" {
  description = "Enable automated research scheduler"
  type        = bool
  default     = false
}

variable "aws_bedrock_model" {
  description = "Model name "
  type        = string
}
