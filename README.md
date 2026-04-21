# SQL Data Cleaning – Nashville Housing Dataset

##  Project Overview

This project focuses on cleaning and preparing a real estate dataset using SQL.

The dataset contains housing data from Nashville, including property details, sale information, and owner data.

The goal is to transform raw data into a clean and structured format ready for analysis.

---

## 🛠️ Tools Used

* SQL Server (SSMS)
* T-SQL

---

##  Dataset

The dataset used in this project:

* Nashville Housing Data (CSV file)
* Stored in the `data/` folder

---

##  Data Cleaning Steps

### 1. Standardizing Date Format

* Converted `SaleDate` to proper DATE format
* Created a new column `SaleDateConverted`

### 2. Handling Missing Values

* Filled missing `PropertyAddress` using self join on `ParcelID`

### 3. Splitting Columns

* Split `PropertyAddress` into:

  * Address
  * City
* Split `OwnerAddress` into:

  * Address
  * City
  * State

### 4. Removing Duplicates

* Used a CTE with `ROW_NUMBER()` to identify duplicates

### 5. Dropping Unused Columns

* Removed unnecessary columns:

  * OwnerAddress
  * TaxDistrict
  * PropertyAddress
  * SaleDate

---

##  Result

The dataset is now:

* Clean
* Structured
* Ready for analysis or visualization




