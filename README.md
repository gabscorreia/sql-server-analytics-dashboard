# 📊 Pipeline de Dados End-to-End: Da Administração em SQL Server ao Dashboard em Power BI

[![SQL Server](https://img.shields.io/badge/SQL%20Server-CC292B?style=for-the-badge&logo=microsoftsqlserver&logoColor=white)](https://www.microsoft.com/sql-server)
[![Power BI](https://img.shields.io/badge/Power%20BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)](https://powerbi.microsoft.com/)
[![Excel](https://img.shields.io/badge/Excel-217346?style=for-the-badge&logo=microsoftexcel&logoColor=white)](https://www.microsoft.com/excel)
[![Git](https://img.shields.io/badge/Git-F05032?style=for-the-badge&logo=git&logoColor=white)](https://git-scm.com/)

## 📌 Visão Geral do Projeto
Este projeto simula uma solução analítica ponta a ponta (*End-to-End*) projetada para estruturar, administrar e analisar dados operacionais e de negócios. 

O fluxo contempla desde a **modelagem e governança no SQL Server**, criação de consultas e visões analíticas com **T-SQL**, validações e análises rápidas no **Excel**, até a publicação de relatórios visuais e interativos no **Power BI**.

---

## 🏗️ Arquitetura e Fluxo de Dados

```text
[ Script DDL / DML ] ──> [ SQL Server ] ──> [ Views / Stored Procedures ]
                                                    │
                                ┌───────────────────┴───────────────────┐
                                ▼                                       ▼
                       [ Power BI Dashboard ]                  [ Análises Ad-hoc Excel ]
