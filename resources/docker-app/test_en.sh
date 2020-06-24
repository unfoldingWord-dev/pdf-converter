#! /usr/bin/env bash
set -e

# Start the en OBS test
cd /app/pdf-converter/public
python3 obs_pdf_converter.py -l en
