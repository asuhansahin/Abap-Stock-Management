# ABAP Stock Management System

## Overview

This ABAP report `ZSTOCK_MANAGEMENT_PROGRAM` is a basic stock management tool. It allows users to view, update, and add stock records using an ALV Grid for easy data management.

## Components

1. **Report**: `ZSTOCK_MANAGEMENT_PROGRAM`
2. **Table**: `zstock_management` - Stores stock records.

## How It Works

1. **Display Stock Records**:
   - The program starts and displays stock data in an ALV Grid.

2. **Update or Add Stock**:
   - Users can update existing stock records or add new ones.
   - The 'SAVE' button updates the record if it exists, otherwise, it inserts a new record.

3. **Navigation**:
   - Use the '&BACK' button to return to the previous screen.

## Key Parts of the Code

- **ALV Grid Setup**:
  - `prepare_alv` sets up the ALV Grid and displays data.
  - `build_fieldcat` defines the columns for the grid.

- **Data Operations**:
  - `update_stock` handles updating or inserting stock records in the database.

## Messages

- **Update Success**: 'Veriler Update Tabloya Kaydedilmiştir'
- **Insert Success**: 'Yeni Veri Tabloya Eklendi'

## Requirements

- Ensure the `zstock_management` table exists with the necessary fields.