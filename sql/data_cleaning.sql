/* =========================================================
   DATA CLEANING PROJECT - NASHVILLE HOUSING
   Database: data_clean
   Table: dbo.Nashville
========================================================= */


select 
* from data_clean.dbo.Nashville

------------------------------------------------------------
-- Standardize Date Format
------------------------------------------------------------

Select SaleDateConverted, convert(Date, SaleDate)
from data_clean.dbo.Nashville

update Nashville
set SaleDate = CONVERT(Date, SaleDate)

alter table Nashville
add SaleDateConverted Date;

update Nashville
set SaleDateConverted = CONVERT(Date, SaleDate)


------------------------------------------------------------
-- Populate Property Address Data
------------------------------------------------------------

Select *
from data_clean.dbo.Nashville 
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from data_clean.dbo.Nashville a
join data_clean.dbo.Nashville b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress= ISNULL(a.PropertyAddress, b.PropertyAddress)
from data_clean.dbo.Nashville a
join data_clean.dbo.Nashville b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


------------------------------------------------------------
-- Break Out PropertyAddress into Individual Columns
-- (Address, City)
------------------------------------------------------------

Select PropertyAddress
from data_clean.dbo.Nashville 
order by ParcelID


SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress)) as City 
FROM data_clean.dbo.Nashville
WHERE PropertyAddress IS NOT NULL
AND PropertyAddress LIKE '%,%'

alter table Nashville
add PropertySplitAddress Nvarchar(255);

update Nashville
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)
WHERE PropertyAddress IS NOT NULL
AND PropertyAddress LIKE '%,%'

alter table Nashville
add PropertySplitCity Nvarchar(255);

update Nashville
set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress))
WHERE PropertyAddress IS NOT NULL
AND PropertyAddress LIKE '%,%'

------------------------------------------------------------
-- Break Out OwnerAddress into Individual Columns
-- (Address, City, State)
------------------------------------------------------------


select OwnerAddress
From data_clean.dbo.Nashville

select 
PARSENAME(REPLACE(OwnerAddress, ',','.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',','.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',','.'), 1)
From data_clean.dbo.Nashville

alter table Nashville
add OwnerSplitAddress Nvarchar(255);

update Nashville
set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',','.'), 3)


alter table Nashville
add OwnerSplitCity Nvarchar(255);

update Nashville
set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.'), 2)


alter table Nashville
add OwnerSplitState Nvarchar(255);

update Nashville
set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',','.'), 1)




------------------------------------------------------------
-- Remove Duplicates
------------------------------------------------------------

WITH RowNumCTE as (
select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					)row_num


from data_clean.dbo.Nashville
)
SELECT *
from RowNumCTE
where row_num > 1 
Order by PropertyAddress



------------------------------------------------------------
-- Delete Unused Columns
------------------------------------------------------------


ALTER TABLE data_clean.dbo.Nashville
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress


ALTER TABLE data_clean.dbo.Nashville
DROP COLUMN SaleDate
