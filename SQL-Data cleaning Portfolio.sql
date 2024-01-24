-- select the database to use

USE house;

SELECT * from housedata;

-- DUPLICATE--------------------------------------------------------------------------------------------------------------
-- Check if there is duplicate
SELECT 
    UniqueID, COUNT(UniqueID)
FROM
    housedata
GROUP BY UniqueID
HAVING COUNT(UniqueID) > 1;  -- There are 4490 duplicates

-- We are going to remove the duplicates in two methods.
-- Method 1:

Select distinct* from housedata; -- There 24007 distint rows

create table housework
Select distinct* from housedata;

drop table housedata;

Alter table housework rename housedata;-- we have a distinct data housedata

-- Method 2:


Select *, row_number() over( 
partition by 
UniqueID,
ParcelID,
LandUse,
PropertyAddress,  
SaleDate,
SalePrice, 
LegalReference, 
SoldAsVacant, 
OwnerName, 
OwnerAddress,  
Acreage 
order by UniqueID ) as rwnumber
from housedata;-- add it in CTE such that you can use 'where clause '    


WIth rwnumberCTE AS (
Select *, row_number() over( 
partition by 
UniqueID,
ParcelID,
LandUse,
PropertyAddress,  
SaleDate,
SalePrice, 
LegalReference, 
SoldAsVacant, 
OwnerName, 
OwnerAddress,  
Acreage 
order by UniqueID ) as rwnumber
from housedata)
Select * from rwnumberCTE
where rwnumber>1 ; -- this will show the duplicate values. It is good to use this method which is exactly the method of Excel. It can help especially when there is no UniqueID




Select * from housedata;
-- next we look at the PropertyAddress. We seperate the address from the city and add them as column


SELECT 
    PropertyAddress,
    SUBSTRING(PropertyAddress,
        1,
        LOCATE(', ', PropertyAddress) - 1) AS Address,
    SUBSTRING(PropertyAddress,
        LOCATE(', ', PropertyAddress) + 2,
        LENGTH(PropertyAddress)) AS City
FROM
    housedata;

Alter table housedata 
add column Address varchar(255),
add column City   Varchar(255);

UPDATE housedata 
SET 
    Address = SUBSTRING(PropertyAddress,
        1,
        LOCATE(', ', PropertyAddress) - 1),
    City = SUBSTRING(PropertyAddress,
        LOCATE(', ', PropertyAddress) + 2,
        LENGTH(PropertyAddress));


Select * from housedata;
-- We look at SaleDate. We want to extract day, Month and year 

SELECT 
    SaleDate,
    DAYNAME(STR_TO_DATE(SaleDate, '%M %d, %Y')) AS SaleDay,
    MONTHNAME(STR_TO_DATE(SaleDate, '%M %d, %Y')) AS SaleMonth,
    YEAR(STR_TO_DATE(SaleDate, '%M %d, %Y')) AS SaleYear
FROM
    housedata;

Alter table housedata
add column SaleDay Varchar(255),
add column SaleMonth Varchar(255),
add column SaleYear Int;

Update housedata
Set
SaleDay=dayname(str_to_date(SaleDate, '%M %d, %Y')) ,
SaleMonth=Monthname(str_to_date(SaleDate, '%M %d, %Y')) ,
SaleYear=Year(str_to_date(SaleDate, '%M %d, %Y'));

-- We look at the OwnerAddress whic contains address, City, and State
-- Before then, we rename Adress to HouseAdress, -HouseCity



ALTER TABLE housedata
CHANGE Address HouseAddress VARCHAR(255),
CHANGE City HouseCity VARCHAR(255);

Select OwnerAddress,
substring(substring(OwnerAddress, locate(',', OwnerAddress)+1),locate(',',substring(OwnerAddress, locate(',', OwnerAddress)+1))+1) as OwnerState,
substring( substring(OwnerAddress, locate(',', OwnerAddress)+1), 1, locate(',', substring(OwnerAddress, locate(',', OwnerAddress)+1))-1) as OwnerCity,
 substring(OwnerAddress, 1,  locate(',',OwnerAddress )-1) as OwnerAddress
 from housedata;
 
 
 Alter table housedata
 Add column Owner_Address Varchar(255),
 Add column OwnerCity Varchar(255),
 Add column OwnerState Varchar(255);
 
 Update housedata
 Set
 OwnerState= substring(substring(OwnerAddress, locate(',', OwnerAddress)+1),locate(',',substring(OwnerAddress, locate(',', OwnerAddress)+1))+1),
OwnerCity=substring( substring(OwnerAddress, locate(',', OwnerAddress)+1), 1, locate(',', substring(OwnerAddress, locate(',', OwnerAddress)+1))-1),
 Owner_Address= substring(OwnerAddress, 1,  locate(',',OwnerAddress )-1) ;
 
 Select * from housedata;
 
 Alter table housedata
 Drop Column OwnerAddress,
  Drop Column Address,
   Drop Column City;
   
Alter table housedata
 Drop Column PropertyAddress;
 
 Alter table housedata
 Drop Column SaleDate;
 
 
 -- Check for Null  values or empty values to populate or delete
 
 Select Distinct(SoldAsVacant) from housedata;
 
 -- there is  in SoldAsVacant column. We are goinyg to change N-No and Y-Yes
 
Select SoldAsVacant,
case
     When SoldAsVacant="Y" then "Yes"
     When SoldAsVacant="N" then "No"
	 Else  SoldAsVacant
End as SoldAs_Vacant
From housedata;
 
 Select Distinct(SoldAsVacant), count(SoldAsVacant) from housedata
 group by SoldAsVacant;
 
 Update  housedata
 set SoldAsVacant = case
     When SoldAsVacant="Y" then "Yes"
     When SoldAsVacant="N" then "No"
	 Else  SoldAsVacant
End ;


-- Create View for Viz.alter

Create View vhousedata as
SELECT 
    *
FROM
    housedata;
    
Select * from vhousedata;