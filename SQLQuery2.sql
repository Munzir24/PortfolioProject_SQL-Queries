-- Converting saledate column to a Date column only

Alter Table Nashvillehousing
Add Sale_Dates Date;

Update Nashvillehousing
SET Sale_Dates = CONVERT(Date,SaleDate)

Select *
From NashvilleHousing

-- populate the property address column where its null

Select *
From NashvilleHousing
Where PropertyAddress is null
order by ParcelID

Select a.PropertyAddress,b.PropertyAddress,isnull(a.PropertyAddress,b.PropertyAddress)
From NashvilleHousing a
Join NashvilleHousing b
on a.ParcelID = b.ParcelID And
a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
SET PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
From NashvilleHousing a
Join NashvilleHousing b
on a.ParcelID = b.ParcelID And
a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

-- Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From NashvilleHousing
--Where PropertyAddress is null
--order by ParcelID

Select
SUBSTRING(PropertyAddress,1, CharIndex(',',propertyaddress)-1) as Address,
SUBSTRING(PropertyAddress, CharIndex(',',propertyaddress)+1,LEN(PropertyAddress)) as City
From NashvilleHousing

Alter table NashvilleHousing
Add PropertyAddress nvarchar(255);

Update NashvilleHousing
SET PropertyAddress = SUBSTRING(PropertyAddress,1, CharIndex(',',propertyaddress)-1) 

Select Address
From NashvilleHousing

Alter Table NashvilleHousing
Add PropertyCity nvarchar(255);

Update NashvilleHousing
SET PropertyCity = SUBSTRING(PropertyAddress, CharIndex(',',propertyaddress)+1,LEN(PropertyAddress))

Select *
From NashvilleHousing

Select OwnerAddress
From NashvilleHousing

Select
PARSENAME(Replace(OwnerAddress,',','.'),3),
PARSENAME(Replace(OwnerAddress,',','.'),2),
PARSENAME(Replace(OwnerAddress,',','.'),1)
From PortfolioProject.dbo.NashvilleHousing

Alter Table NashvilleHousing
add OwnersAddress nvarchar(255);

Update NashvilleHousing
SET OwnersAddress = PARSENAME(Replace(OwnerAddress,',','.'),3)


Alter Table NashvilleHousing
add OwnersCity nvarchar(255);

Update NashvilleHousing
SET OwnersCity = PARSENAME(Replace(OwnerAddress,',','.'),2)

Alter Table NashvilleHousing
add OwnersState nvarchar(255);

Update NashvilleHousing
SET OwnersState = PARSENAME(Replace(OwnerAddress,',','.'),1)

Select *
From NashvilleHousing


-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant),Count(SoldAsVacant)
From NashvilleHousing
Group by SoldAsVacant
order by Count(SoldAsVacant)

Select SoldAsVacant,
Case when SoldAsVacant = 'Y' then 'Yes'
     when SoldAsVacant = 'N' then 'No'
	 Else SoldAsVacant
	 End
From NashvilleHousing

Update NashvilleHousing
SET SoldASVacant = Case when SoldAsVacant = 'Y' then 'Yes'
     when SoldAsVacant = 'N' then 'No'
	 Else SoldAsVacant
	 End

Select Distinct(SoldAsVacant),Count(SoldAsVacant)
From NashvilleHousing
Group by SoldAsVacant
order by 2

-- Remove Duplicates
With RowNumCTE As
(
Select *,ROW_NUMBER() Over
(Partition by ParcelId,PropertyAddress,SaleDate,LegalReference
Order by UniqueID) row_num
From NashvilleHousing
)

Select *
From RowNumCTE
Where row_num > 1
--order by row_num

Select *
From NashvilleHousing

-- delete non-usable columns

Select *
From NashvilleHousing

Alter table NashvilleHousing
Drop Column PropertyAddress,OwnerAddress,SaleDate,TaxDistrict,SaleData,Sale_Dates

Alter table NashvilleHousing
Drop Column SaleDateConverted

Alter table NashvilleHousing
Drop Column PropertyAddress,PropertyCity


Select *
From NashvilleHousing

