
--Standardize Date Format

SELECT SaleDate,Convert(date,SaleDate)
From PortfolioProject..NashvilleHousing

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(DATE, SaleDate)

SELECT SaleDateConverted, Convert(date,SaleDate)
FROM PortfolioProject..NashvilleHousing


---Populate Property Adress data

SELECT PropertyAddress
FROM PortfolioProject..NashvilleHousing
WHERE PropertyAddress IS null


SELECT A.ParcelID, A.PropertyAddress, B.ParcelID, B.PropertyAddress, ISNULL(A.PropertyAddress,B.PropertyAddress)
FROM PortfolioProject..NashvilleHousing A
JOIN PortfolioProject..NashvilleHousing B
     ON A.ParcelID = B.ParcelID
	 AND A.[UniqueID ] <> B.[UniqueID ]
WHERE A.PropertyAddress IS NULL

update A
SET PropertyAddress = ISNULL(A.PropertyAddress,B.PropertyAddress)
FROM PortfolioProject..NashvilleHousing A
JOIN PortfolioProject..NashvilleHousing B
     ON A.ParcelID = B.ParcelID
	 AND A.[UniqueID ] <> B.[UniqueID ]

--Breaking out Adress into Individual Columns (Adress, city, State)

SELECT OwnerAddress
FROM NashvilleHousing

SELECT 
PARSENAME(REPLACE(OwnerAddress, ',', '.') ,3) ,
PARSENAME(REPLACE(OwnerAddress, ',', '.') ,2) ,
PARSENAME(REPLACE(OwnerAddress, ',', '.') ,1)
from NashvilleHousing

ALTER TABLE NashvilleHousing
Add OwnerAddress1 varchar(250)

Update NashvilleHousing
SET OwnerAddress1 = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,3)

ALTER TABLE NashvilleHousing
Add OwnerCity varchar(250)

Update NashvilleHousing
SET OwnerCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,2)

ALTER TABLE NashvilleHousing
Add OwnerState varchar(250)

Update NashvilleHousing
SET OwnerState = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,1)

SELECT *
FROM NashvilleHousing


--Change Y and No in 'Sold in Vacant'

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM PortfolioProject..NashvilleHousing
GROUP BY SoldAsVacant
Order by 2

Select SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END  AS SoldAsVacantUpdated
FROM PortfolioProject..NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END 



-- Remove Dublicates

SELECT*, ROW_NUMBER() OVER ( 
Partition by ParcelID,PropertyAddress, SalePrice,SaleDate,LegalReference
ORDER BY UniqueID) row_num
FROM PortfolioProject.. NashvilleHousing

WITH RowNumCTE AS (
SELECT*, ROW_NUMBER() OVER ( 
Partition by ParcelID,PropertyAddress, SalePrice,SaleDate,LegalReference
ORDER BY UniqueID) row_num
FROM PortfolioProject.. NashvilleHousing
)

SELECT*
FROM RowNumCTE
WHERE row_num > 1

DELETE
FROM RowNumCTE
WHERE row_num > 1


--DELETE UNUSED COLUMNS

SELECT*
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate



