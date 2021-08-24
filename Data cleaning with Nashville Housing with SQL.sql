  
/*
Cleaning Data in SQL Queries
*/


Select *
From [Portfolio project]..NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format


Select saleDateConverted, CONVERT(Date,SaleDate)
From [Portfolio project]..NashvilleHousing


Update [Portfolio project]..NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

-- If it doesn't Update properly

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update[Portfolio project]..NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)


 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select *
From [Portfolio project]..NashvilleHousing
--Where PropertyAddress is null
order by ParcelID



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From [Portfolio project]..NashvilleHousing a
JOIN [Portfolio project]..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From [Portfolio project]..NashvilleHousing a
JOIN [Portfolio project]..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null




--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From [Portfolio project]..NashvilleHousing


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as PropertySplitAddress
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as PropertySplitCity
From [Portfolio project]..NashvilleHousing


--SUBSTRING() function extracts some characters from a string
--SUBSTRING(string, start, length)
--CHARINDEX() function searches for a substring in a string, and returns the position.
--LENGTH function (LEN) returns the number of characters in a string

ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update [Portfolio project]..NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE [Portfolio project]..NashvilleHousing
Add PropertySplitCity Nvarchar(255)

Update [Portfolio project]..NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




Select *
From [Portfolio project]..NashvilleHousing





Select OwnerAddress
From [Portfolio project]..NashvilleHousing


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From [Portfolio project]..NashvilleHousing



ALTER TABLE [Portfolio project]..NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update [Portfolio project]..NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE [Portfolio project]..NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update[Portfolio project]..NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE [Portfolio project]..NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update [Portfolio project]..NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From [Portfolio project]..NashvilleHousing





--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant)
From [Portfolio project]..NashvilleHousing


Select Distinct(SoldAsVacant), Count(SoldAsVacant) --COUNT(*) returns the number of rows in a specified table
From [Portfolio project]..NashvilleHousing
Group by SoldAsVacant
order by 2



Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From [Portfolio project]..NashvilleHousing

Update [Portfolio project]..NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END






-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) AS row_num

From [Portfolio project]..NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) AS row_num

From [Portfolio project]..NashvilleHousing
--order by ParcelID
)
Delete --this is the difference between this query and the one above.it deletes all the duplicate rows.
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress. when using delete we don't use the order by clause



--OVER - Specify the order of the rows
--ORDER BY - Provide sort order for the records.
--Partition by clause is an optional part of Row_Number function and if you don't use it all the records of the result-set will be considered as a part of single record group or a single partition and then ranking functions are applied
--The ROW_NUMBER function enumerates the rows in the sort order defined in the over clause
--The Row_Numaber function is an important function when you do paging in SQL Server. The Row_Number function is used to provide consecutive numbering of the rows in the result by the order selected in the OVER clause for each partition specified in the OVER clause. It will assign the value 1 for the first row and increase the number of the subsequent rows.

Select *
From [Portfolio project]..NashvilleHousing




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From [Portfolio project]..NashvilleHousing


ALTER TABLE [Portfolio project]..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
















