select * from laptopdata;


-- DROPPING COLUMN :- mistakenly added processor column as integer
ALTER TABLE  laptopdata DROP COLUMN processor_speed ;
-- adding new column fro processor speed 
ALTER TABLE  laptopdata ADD COLUMN processor_speed DECIMAL (10,1);
select * from laptopdata;

--  update the table with new column
UPDATE laptopdata ;
SET processor_speed= REPLACE(SUBSTRING_INDEX(Cpu," ",-1),"GHz","" ) ;
select * from laptopdata;
-- select Cpu ,REPLACE(SUBSTRING_INDEX(Cpu," ",-1),"GHz","" ) from laptopdata




-- adding processor series with null values

ALTER TABLE laptopdata ADD COLUMN processor_series  VARCHAR (30);


-- updating laptopdata by adding processor_series and their values 
UPDATE laptopdata;
SET processor_series=SUBSTRING_INDEX(SUBSTRING_INDEX(Cpu," ",3)," ",-2);
SELECT * from laptopdata;

-- ADDING CPU_BRAND
ALTER TABLE laptopdata ADD COLUMN cpu_brand VARCHAR (30);
UPDATE laptopdata;
set  cpu_brand = SUBSTRING_INDEX(Cpu," ",1);
select * from laptopdata;
-- dropping Cpu column after extracting every information '
 ALTER TABLE laptopdata DROP COLUMN Cpu;
 
 /* add column full hd
      purpose : a device has full hd or not, if has=1 , else=0
      1 add a new column having null values 
      update the column's table with values (0,1)*/
      
ALTER TABLE laptopdata ADD COLUMN full_hd INTEGER ;

UPDATE laptopdata
SET full_hd=   
 CASE 
     WHEN ScreenResolution LIKE '%Full HD%' THEN 1 
     ELSE 0
 END ;
 select * from laptopdata;
 
 
 -- add column Touchscreen ; 1 IF YES ELSE NO
 
 ALTER TABLE laptopdata ADD COLUMN touchscreen  integer; 
UPDATE  laptopdata
 set touchscreen =
	 case 
		when screenresolution like lower('%Touchscreen%') then 1
		else 0
	 end;
     
     
select * from  laptopdata;

-- ADDING A CILUMN FOR PANEL TYPE
ALTER TABLE laptopdata ADD COLUMN panel_type  INTEGER ;
UPDATE laptopdata 
set panel_type =
case 
	when ScreenResolution like lower('%IPS PANEL%') THEN 1
    else 0
    END ;
select * from laptopdata;

-- extracting width and height columns
alter table laptopdata add column screen_width integer ;
update laptopdata
set screen_width= SUBSTRING_INDEX(SUBSTRING_INDEX(ScreenResolution," ",-1),'x',1) ;

 -- alter table laptopdata add column screen_height integer ;
 
update laptopdata
set screen_height= SUBSTRING_INDEX(SUBSTRING_INDEX(ScreenResolution," ",-1),'x',-1);

select * from laptopdata;

-- drop screenresolution column : extracted all data 

ALTER TABLE laptopdata DROP COLUMN ScreenResolution;


-- extraxcting everuthing from gpu
select *,last_value(price) over 
(partition by Company order by Price asc rows between unbounded preceding and unbounded following)  
from laptopdata;

ALTER TABLE laptopdata ADD COLUMN gpu_brand VARCHAR (255);

UPDATE laptopdata
set gpu_brand=SUBSTRING_INDEX(Gpu,' ', 1) ;

-- add column for gpu series
ALTER TABLE laptopdata ADD COLUMN gpu_series VARCHAR (30);

update laptopdata
set gpu_series=SUBSTRING_INDEX(SUBSTRING_INDEX(Gpu," " , 3 )," " ,-2);
select * from laptopdata;
-- ADDING GPU MODEL 
ALTER TABLE laptopdata ADD COLUMN gpu_model VARCHAR(255);
-- extracted gpu model
/*SELECT Gpu,SUBSTRING_INDEX(Gpu," ",-1) ,
CASE
	WHEN SUBSTRING_INDEX(Gpu," ",-1) like '%Graphics%' then null
    else SUBSTRING_INDEX(Gpu," ",-1)
end as "gpu_model"
FroM laptopdata*/

-- updated table by adding gpu_model column
UPDATE laptopdata
SET gpu_model= CASE
	WHEN SUBSTRING_INDEX(Gpu," ",-1) like '%Graphics%' then null
    else SUBSTRING_INDEX(Gpu," ",-1)
    end;
    
select * from laptopdata;

ALTER TABLE laptopdata DROP COLUMN Gpu;
select * from laptopdata;

SELECT Memory from laptopdata;
-- CREAT COLUMN FOR SSD GB WITH NULL VALUES
ALTER TABLE laptopdata ADD COLUMN ssd_gb integer;

-- EXTRACTING SSD DATA FROM ACTUAL TABLE 
-- IF A LAPTOP HAS NO SSD ITS REPRESENTED AS "0"
-- if ss is 1 it means it is 1TB

 

UPDATE laptopdata
set ssd_gb=	case 
		when SUBSTRING_INDEX(Memory," ",2) like '%SSD' THEN REPLACE(REPLACE(substring_index(SUBSTRING_INDEX(Memory," ",2)," ",1),"GB",""),"TB","") 
		else 0
    end ;
-- ADDING A COLUMN FOR HDD IF IT HAS HDD THEN 1 OR ELSE 0
ALTER TABLE laptopdata ADD COLUMN hdd_gb integer; 
    
-- UPDATE laptopndata
-- SET hdd_gb=
-- case 
	-- when temp_hdd='1' then CAST(temp_hdd AS UNSIGNED)*1024
    -- else 0
-- end  
UPDATE laptopdata
SET hdd_gb=
case  
	 when REPLACE(substring_index(Memory," ",-2),"TB HDD","") ='1' 
     then CAST(REPLACE(SUBSTRING_INDEX(Memory, " ", -2), "TB HDD", "") AS UNSIGNED) * 1024 

     ELSE 0
END ; 

-- create a column for memory(flash storage ) if it has flash storage then 1 else 0
ALTER TABLE laptopdata ADD COLUMN is_flash_storage INTEGER ;


UPDATE laptopdata
SET is_flash_storage=
CASE 

	 WHEN SUBSTRING_INDEX(Memory," ",-2) LIKE '%Flash Storage%' 
     THEN 1 
     ELSE 0
END ;

-- deleted memory column after extracted everything
ALTER TABLE laptopdata DROP COLUMN Memory

