.PHONY: setup build docs clean test snapshot-demo

PYTHON ?= python
VENV ?= .venv
DBT := $(VENV)/Scripts/dbt
ifeq ($(OS),Windows_NT)
  PIP := $(VENV)/Scripts/pip
  ACTIVATE := $(VENV)/Scripts/Activate.ps1
else
  PIP := $(VENV)/bin/pip
  DBT := $(VENV)/bin/dbt
endif

setup:
	$(PYTHON) -m venv $(VENV)
	$(PIP) install --upgrade pip
	$(PIP) install -r requirements.txt
	@echo "Setup complete. On Windows: .\\.venv\\Scripts\\Activate.ps1"

build:
	$(DBT) deps --profiles-dir .
	$(DBT) seed --profiles-dir .
	$(DBT) snapshot --profiles-dir .
	$(DBT) run --profiles-dir .
	$(DBT) test --profiles-dir .
	@echo "--- second batch (incremental + snapshot) ---"
	cp data_batches/raw_account_attributes_v2.csv seeds/raw_account_attributes.csv
	$(DBT) seed --select raw_trades_batch2 raw_account_attributes --profiles-dir .
	$(DBT) run --select stg_account_attributes stg_trades fct_trades mart_daily_trade_volume mart_instrument_activity --vars '{"load_batch_2": true}' --profiles-dir .
	$(DBT) snapshot --profiles-dir .
	$(DBT) test --profiles-dir .
	cp data_batches/raw_account_attributes_v1_restore.csv seeds/raw_account_attributes.csv 2>/dev/null || true

docs:
	$(DBT) docs generate --profiles-dir .
	$(DBT) docs serve --profiles-dir . --port 8080

clean:
	$(DBT) clean --profiles-dir .
	rm -rf target logs

test:
	$(DBT) test --profiles-dir .

