# Alex — Agentic Financial Planning Platform

Alex is a **serverless, agentic AI platform** for portfolio analysis and long-term financial planning.  
It leverages **specialized AI agents**, **retrieval-augmented intelligence**, and **cloud-native infrastructure** to generate professional-grade investment insights.

The system is designed around **agent orchestration, observability, and scalability**, following modern production best practices.

---

## Key Features

- 🧠 **Agentic Architecture** with clear role separation
- 📊 **Automated Portfolio Analysis & Visualization**
- 🔮 **Retirement Projections & Monte Carlo Simulations**
- 📚 **Continuous Market Research (Autonomous Agent)**
- 🔍 **End-to-End Observability (Langfuse + LLM Traces)**
- ☁️ **Fully Serverless AWS Infrastructure**
- 🧩 **Retrieval-Augmented Generation (S3 Vectors + Embeddings)**

---

## High-Level Architecture
User → API → Planner (Orchestrator)\
├── Instrument Tagger\
├── Report Writer\
├── Chart Maker\
├── Retirement Specialist\
└── Research Context (S3 Vectors)

Autonomous Researcher → Market Intelligence → Knowledge Base

---

## Repository Structure



├── backend/ \
│ ├── api/# API Gateway entrypoint \
│ ├── planner/ # Orchestrator agent\
│ ├── tagger/ # Instrument classification agent\
│ ├── reporter/ # Portfolio report generator\
│ ├── charter/ # Chart & visualization agent\
│ ├── retirement/ # Retirement projection agent\
│ ├── research/ # Autonomous market research agent\
│ ├── ingest/ # Data ingestion & seeding\
│ ├── scheduler/ # EventBridge-triggered jobs\
│ └── database/ # Shared Aurora Data API access\
│
├── frontend/
│ └── next/ # Next.js user dashboard
│
└── terraform/
├── agents/ # Agent Lambdas & IAM\
├── database/ # Aurora Serverless v2\
├── research/ # Researcher scheduling & vectors\
├── ingest/ # Ingestion pipelines\
├── sagemaker/ # Embeddings & vectorization\
├── frontend/ # Frontend hosting\
└── dashboard/ # Observability dashboards\

---

## Agent Overview

| Agent | Responsibility |
|---|---|
| **Financial Planner** | Orchestrates analysis and aggregates results |
| **InstrumentTagger** | Classifies assets (sector, region, asset class) |
| **Report Writer** | Generates portfolio narratives and insights |
| **Chart Maker** | Produces visualization-ready datasets |
| **Retirement Specialist** | Projects long-term income and sustainability |
| **Researcher (Autonomous)** | Continuously gathers market intelligence |

---

## Observability & Tracing

The platform implements **multi-layer observability**:

- **CloudWatch** – Infrastructure metrics & errors
- **LLM Traces** – Model latency, tokens, failures
- **Langfuse** – Agent steps, tool usage, prompt versions

Each analysis job is fully traceable from **API request → agent execution → LLM calls**.

---

## Data & Storage

### Database
- **Aurora Serverless v2 (PostgreSQL + Data API)**
- JSONB-based agent outputs
- Strong schema validation via Pydantic
- No logs or traces stored in the database

### Knowledge Base
- **S3 + Vector embeddings**
- Populated by the autonomous Researcher
- Retrieved dynamically by the Planner for context-aware analysis

---

## Technology Stack

**Backend**
- AWS Lambda
- API Gateway
- Aurora Serverless v2 (PostgreSQL)
- EventBridge
- S3 + Embeddings
- Langfuse (observability)

**Frontend**
- Next.js
- Recharts
- Server-side rendering

**Infrastructure**
- Terraform
- IAM (least privilege)
- CloudWatch & Budgets

---

## Design Principles

1. **Single Responsibility Agents**
2. **Stateless Compute, Stateful Storage**
3. **Parallel Execution for Performance**
4. **Observability First**
5. **Infrastructure as Code**
6. **Incremental Extensibility**

---

## Future Enhancements

- Tax Optimization Agent
- Portfolio Rebalancing Agent
- Risk & Volatility Analysis
- Real-time Market Data Integration

---

## Disclaimer

This project is for **educational and research purposes only**.  
It does **not** constitute financial advice.

---

## Author

**Djallel Brahmia**  
AI / Data Engineer  
Agentic Systems • Cloud-Native Architecture • Applied Machine Learning
