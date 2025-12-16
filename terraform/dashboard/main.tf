terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  name_prefix = "alex"

  common_tags = {
    Project   = "alex"
    Part      = "dashboard"
    ManagedBy = "terraform"
  }
}

resource "aws_cloudwatch_dashboard" "ai_model_usage" {
  dashboard_name = "${local.name_prefix}-ai-model-usage"

  dashboard_body = jsonencode({
    widgets = [
        
      # Bedrock Model Invocations
      {
  type   = "metric"
  width  = 12
  height = 6

  properties = {
    region = var.bedrock_region

    metrics = [
      # === Europe Regions ===
      ["AWS/Bedrock", "Invocations", "ModelId", var.bedrock_model_id, {
        region = "eu-central-1", id = "m1", label = "eu-central-1"
      }],
      ["AWS/Bedrock", "Invocations", "ModelId", var.bedrock_model_id, {
        region = "eu-west-1", id = "m2", label = "eu-west-1"
      }],
      ["AWS/Bedrock", "Invocations", "ModelId", var.bedrock_model_id, {
        region = "eu-west-2", id = "m3", label = "eu-west-2"
      }],
      ["AWS/Bedrock", "Invocations", "ModelId", var.bedrock_model_id, {
        region = "eu-west-3", id = "m4", label = "eu-west-3"
      }],
      ["AWS/Bedrock", "Invocations", "ModelId", var.bedrock_model_id, {
        region = "eu-north-1", id = "m5", label = "eu-north-1"
      }],

      # === Sum All EU ===
      [{ expression = "m1 + m2 + m3 + m4 + m5",
         id = "eu_total",
         label = "EU Total Invocations",
         color = "#000000"
      }]
    ]

    view    = "timeSeries"
    stacked = false
    title   = "Bedrock Invocations - Europe Total"
    period  = 300
  }
},
   {
  type   = "metric"
  width  = 12
  height = 6

  properties = {
    region = var.bedrock_region

    metrics = [
      # ==== Input Tokens Across Europe ====
      ["AWS/Bedrock", "InputTokenCount", "ModelId", var.bedrock_model_id,
        { region = "eu-central-1", id="i1", label="Input eu-central-1", stat="Sum" }],
      ["AWS/Bedrock", "InputTokenCount", "ModelId", var.bedrock_model_id,
        { region = "eu-west-1", id="i2", label="Input eu-west-1", stat="Sum" }],
      ["AWS/Bedrock", "InputTokenCount", "ModelId", var.bedrock_model_id,
        { region = "eu-west-2", id="i3", label="Input eu-west-2", stat="Sum" }],
      ["AWS/Bedrock", "InputTokenCount", "ModelId", var.bedrock_model_id,
        { region = "eu-west-3", id="i4", label="Input eu-west-3", stat="Sum" }],
      ["AWS/Bedrock", "InputTokenCount", "ModelId", var.bedrock_model_id,
        { region = "eu-north-1", id="i5", label="Input eu-north-1", stat="Sum" }],

      # ==== Output Tokens Across Europe ====
      ["AWS/Bedrock", "OutputTokenCount", "ModelId", var.bedrock_model_id,
        { region = "eu-central-1", id="o1", label="Output eu-central-1", stat="Sum" }],
      ["AWS/Bedrock", "OutputTokenCount", "ModelId", var.bedrock_model_id,
        { region = "eu-west-1", id="o2", label="Output eu-west-1", stat="Sum" }],
      ["AWS/Bedrock", "OutputTokenCount", "ModelId", var.bedrock_model_id,
        { region = "eu-west-2", id="o3", label="Output eu-west-2", stat="Sum" }],
      ["AWS/Bedrock", "OutputTokenCount", "ModelId", var.bedrock_model_id,
        { region = "eu-west-3", id="o4", label="Output eu-west-3", stat="Sum" }],
      ["AWS/Bedrock", "OutputTokenCount", "ModelId", var.bedrock_model_id,
        { region = "eu-north-1", id="o5", label="Output eu-north-1", stat="Sum" }],

      # ==== TOTAL INPUT ====
      [{ expression = "i1 + i2 + i3 + i4 + i5",
         id = "input_total",
         label = "EU Total Input Tokens"
      }],

      # ==== TOTAL OUTPUT ====
      [{ expression = "o1 + o2 + o3 + o4 + o5",
         id = "output_total",
         label = "EU Total Output Tokens"
      }]
    ]

    view    = "timeSeries"
    stacked = true
    title   = "Bedrock Token Usage – Europe Total"
    period  = 300
    stat    = "Sum"
  }
}
,{
  type   = "metric"
  width  = 12
  height = 6

  properties = {
    region = var.bedrock_region

    metrics = [
      # ===== Average Latency =====
      ["AWS/Bedrock", "InvocationLatency", "ModelId", var.bedrock_model_id,
        { region = "eu-central-1", id="a1", stat="Average", label="Avg eu-central-1" }],
      ["AWS/Bedrock", "InvocationLatency", "ModelId", var.bedrock_model_id,
        { region = "eu-west-1", id="a2", stat="Average", label="Avg eu-west-1" }],
      ["AWS/Bedrock", "InvocationLatency", "ModelId", var.bedrock_model_id,
        { region = "eu-west-2", id="a3", stat="Average", label="Avg eu-west-2" }],
      ["AWS/Bedrock", "InvocationLatency", "ModelId", var.bedrock_model_id,
        { region = "eu-west-3", id="a4", stat="Average", label="Avg eu-west-3" }],
      ["AWS/Bedrock", "InvocationLatency", "ModelId", var.bedrock_model_id,
        { region = "eu-north-1", id="a5", stat="Average", label="Avg eu-north-1" }],

      # ===== Aggregated Europe =====

      # Average of averages
      [{ expression = "(a1 + a2 + a3 + a4 + a5) / 5",
         id = "avg_total",
         label = "EU Avg Latency"
      }],

    ]

    view    = "timeSeries"
    stacked = false
    title   = "Bedrock Latency – Europe Summary"
    period  = 300
  }
}
,
      # SageMaker Endpoint Invocations
      {
        type   = "metric"
        width  = 12
        height = 6
        properties = {
          metrics = [
            [{ expression = "SEARCH(' {AWS/SageMaker,EndpointName,VariantName} MetricName=\"Invocations\" EndpointName=\"alex-embedding-endpoint\" ', 'Sum')", id = "s1", label = "Invocations", color = "#1f77b4" }],
            [{ expression = "SEARCH(' {AWS/SageMaker,EndpointName,VariantName} MetricName=\"Invocation4XXErrors\" EndpointName=\"alex-embedding-endpoint\" ', 'Sum')", id = "s2", label = "4XX Errors", color = "#ff7f0e" }],
            [{ expression = "SEARCH(' {AWS/SageMaker,EndpointName,VariantName} MetricName=\"Invocation5XXErrors\" EndpointName=\"alex-embedding-endpoint\" ', 'Sum')", id = "s3", label = "5XX Errors", color = "#d62728" }]
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.aws_region
          title   = "SageMaker Embedding Endpoint Invocations"
          period  = 300
          yAxis = {
            left = {
              label     = "Count"
              showUnits = false
            }
          }
        }
      },
      # SageMaker Model Latency
      {
        type   = "metric"
        width  = 12
        height = 6
        properties = {
          metrics = [
            [{ expression = "SEARCH(' {AWS/SageMaker,EndpointName,VariantName} MetricName=\"ModelLatency\" EndpointName=\"alex-embedding-endpoint\" ', 'Average')", id = "ml1", label = "Average Latency", color = "#2ca02c" }],
            [{ expression = "SEARCH(' {AWS/SageMaker,EndpointName,VariantName} MetricName=\"ModelLatency\" EndpointName=\"alex-embedding-endpoint\" ', 'Maximum')", id = "ml2", label = "Max Latency", color = "#d62728" }],
            [{ expression = "SEARCH(' {AWS/SageMaker,EndpointName,VariantName} MetricName=\"ModelLatency\" EndpointName=\"alex-embedding-endpoint\" ', 'Minimum')", id = "ml3", label = "Min Latency", color = "#1f77b4" }]
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.aws_region
          title   = "SageMaker Model Latency"
          period  = 300
          yAxis = {
            left = {
              label     = "Latency (μs)"
              showUnits = false
            }
          }
        }
      }
    ]
  })

}
resource "aws_cloudwatch_dashboard" "agent_performance" {
  dashboard_name = "${local.name_prefix}-agent-performance"

  dashboard_body = jsonencode({
    widgets = [
      # Agent Execution Times
      {
        type   = "metric"
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/Lambda", "Duration", "FunctionName", "alex-planner", { stat = "Average", label = "Planner", id = "m1", color = "#1f77b4" }],
            [".", ".", ".", "alex-reporter", { stat = "Average", label = "Reporter", id = "m2", color = "#2ca02c" }],
            [".", ".", ".", "alex-charter", { stat = "Average", label = "Charter", id = "m3", color = "#ff7f0e" }],
            [".", ".", ".", "alex-retirement", { stat = "Average", label = "Retirement", id = "m4", color = "#d62728" }],
            [".", ".", ".", "alex-tagger", { stat = "Average", label = "Tagger", id = "m5", color = "#9467bd" }]
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.aws_region
          title   = "Agent Execution Times"
          period  = 300
          stat    = "Average"
          yAxis = {
            left = {
              label     = "Duration (ms)"
              showUnits = false
            }
          }
        }
      },
      # Agent Error Rates
      {
        type   = "metric"
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/Lambda", "Errors", "FunctionName", "alex-planner", { stat = "Sum", label = "Planner Errors", id = "e1", color = "#1f77b4" }],
            [".", ".", ".", "alex-reporter", { stat = "Sum", label = "Reporter Errors", id = "e2", color = "#2ca02c" }],
            [".", ".", ".", "alex-charter", { stat = "Sum", label = "Charter Errors", id = "e3", color = "#ff7f0e" }],
            [".", ".", ".", "alex-retirement", { stat = "Sum", label = "Retirement Errors", id = "e4", color = "#d62728" }],
            [".", ".", ".", "alex-tagger", { stat = "Sum", label = "Tagger Errors", id = "e5", color = "#9467bd" }]
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.aws_region
          title   = "Agent Error Rates"
          period  = 300
          stat    = "Sum"
          yAxis = {
            left = {
              label     = "Error Count"
              showUnits = false
            }
          }
        }
      },
      # Agent Invocations
      {
        type   = "metric"
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/Lambda", "Invocations", "FunctionName", "alex-planner", { stat = "Sum", label = "Planner", id = "i1", color = "#1f77b4" }],
            [".", ".", ".", "alex-reporter", { stat = "Sum", label = "Reporter", id = "i2", color = "#2ca02c" }],
            [".", ".", ".", "alex-charter", { stat = "Sum", label = "Charter", id = "i3", color = "#ff7f0e" }],
            [".", ".", ".", "alex-retirement", { stat = "Sum", label = "Retirement", id = "i4", color = "#d62728" }],
            [".", ".", ".", "alex-tagger", { stat = "Sum", label = "Tagger", id = "i5", color = "#9467bd" }]
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.aws_region
          title   = "Agent Invocation Counts"
          period  = 300
          stat    = "Sum"
          yAxis = {
            left = {
              label     = "Invocation Count"
              showUnits = false
            }
          }
        }
      },
      # Concurrent Executions
      {
        type   = "metric"
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/Lambda", "ConcurrentExecutions", "FunctionName", "alex-planner", { stat = "Maximum", label = "Planner", id = "c1", color = "#1f77b4" }],
            [".", ".", ".", "alex-reporter", { stat = "Maximum", label = "Reporter", id = "c2", color = "#2ca02c" }],
            [".", ".", ".", "alex-charter", { stat = "Maximum", label = "Charter", id = "c3", color = "#ff7f0e" }],
            [".", ".", ".", "alex-retirement", { stat = "Maximum", label = "Retirement", id = "c4", color = "#d62728" }],
            [".", ".", ".", "alex-tagger", { stat = "Maximum", label = "Tagger", id = "c5", color = "#9467bd" }]
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.aws_region
          title   = "Concurrent Executions"
          period  = 300
          stat    = "Maximum"
          yAxis = {
            left = {
              label     = "Concurrent Executions"
              showUnits = false
            }
          }
        }
      },
      # Throttles
      {
        type   = "metric"
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/Lambda", "Throttles", "FunctionName", "alex-planner", { stat = "Sum", label = "Planner Throttles", id = "t1", color = "#1f77b4" }],
            [".", ".", ".", "alex-reporter", { stat = "Sum", label = "Reporter Throttles", id = "t2", color = "#2ca02c" }],
            [".", ".", ".", "alex-charter", { stat = "Sum", label = "Charter Throttles", id = "t3", color = "#ff7f0e" }],
            [".", ".", ".", "alex-retirement", { stat = "Sum", label = "Retirement Throttles", id = "t4", color = "#d62728" }],
            [".", ".", ".", "alex-tagger", { stat = "Sum", label = "Tagger Throttles", id = "t5", color = "#9467bd" }]
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.aws_region
          title   = "Agent Throttles"
          period  = 300
          stat    = "Sum"
          yAxis = {
            left = {
              label     = "Throttle Count"
              showUnits = false
            }
          }
        }
      }
    ]
  })

}
