
select * from host_toronto_df 
select * from listing_toronto_df
select * from review_toronto_df

---Q.a TORONTO



select a.host_id,host_name,substring(host_location,0,charindex(',',host_location,1)) as host_location
,avg(isnull(host_acceptance_rate,0)) as avg_host_acceptance_rate,
avg(isnull(host_response_rate,0)) as avg_host_response_rate,host_has_profile_pic,host_identity_verified,
avg(instant_bookable) as avg_instant_bookable,round(avg(review_scores_rating),1) as avg_review_scores_rating
,round(avg(review_scores_value),1) as avg_review_scores_value,month(date) as months,count(c.id)as bookings_per_month,host_is_superhost
from host_toronto_df as a  join listing_toronto_df as b on a.host_id=b.host_id join review_toronto_df as c
on b.id=c.listing_id
where host_location like 'toronto%'
group by a.host_id,host_name,host_location,host_has_profile_pic,host_identity_verified,host_is_superhost,month(date)
order by host_is_superhost,months


--q.b torronto top 3 crucials



select host_is_superhost,substring(host_location,0,charindex(',',host_location,1)) host_location,round(isnull(avg(review_scores_rating),0),1) as avg_review_scores_rating,
round(isnull(avg(review_scores_cleanliness),0),1) as avg_review_scores_cleanliness,round(avg(price),1) as avg_price
from host_toronto_df as a  
join listing_toronto_df as b on a.host_id=b.host_id 
where host_location like 'toronto%'
group by host_is_superhost,substring(host_location,0,charindex(',',host_location,1))
order by host_is_superhost desc

---q.c---torronto

select top 10 host_is_superhost,host_location,reviewer_name,substring(comments,1,charindex('.',comments,1)) as comments 
from host_toronto_df as a  join listing_toronto_df as b on a.host_id=b.host_id join review_toronto_df as c
on b.id=c.listing_id
where host_is_superhost like 'TRUE' and host_location like 'toronto%'

union

select top 10 host_is_superhost,host_location,reviewer_name,substring(comments,1,charindex('.',comments,1)) as comments 
from host_toronto_df as a  join listing_toronto_df as b on a.host_id=b.host_id join review_toronto_df as c
on b.id=c.listing_id
where host_is_superhost like 'FALSE' and host_location like 'toronto%'

---q.d property type

select host_is_superhost,host_location,property_type,count(b.host_id) as count_of_people 
from host_toronto_df as a  join listing_toronto_df as b on a.host_id=b.host_id 
where host_location like 'toronto%'
group by host_is_superhost,host_location,property_type
order by property_type
---q.d toronto
---d. Analyze do Super Hosts tend to have large property types as compared to Other Host
with cte as (select * from
(select * , dense_rank() over (partition by host_is_superhost order by total_properties_types desc) ranking from
(select ht.host_id , host_name ,substring(host_location,0,charindex(',',host_location,1)) host_location,host_is_superhost,
count( property_type) total_properties_types from host_toronto_df ht
join listing_toronto_df lt
on ht.host_id = lt.host_id
where host_location like 'toronto%'
group by ht.host_id , host_name ,host_location,host_is_superhost) a) b
where ranking <= 5)
select host_id , host_name , host_location , host_is_superhost,total_properties_types from cte

---Q.E

SELECT	HOST_IS_superhost ,substring(host_location,0,charindex(',',host_location,1)) as host_location
, round(avg(review_scores_communication),2) as avg_review_scores_communication
from host_toronto_df a join listing_toronto_df b on a.host_id=b.host_id
where host_location like 'TORONTO%'
group by host_is_superhost,host_location




---q.a-vancouver


select a.host_id, host_name,substring(host_location,0,charindex(',',host_location,1)) as host_location
,isnull(avg(host_acceptance_rate),0) as avg_acceptance_rate,
isnull(avg(host_response_rate),0) as avg_response_rate
,host_has_profile_pic,host_identity_verified,avg(instant_bookable) as avg_instant_bookable
,isnull(round(avg(review_scores_rating),1),0) as review_scores_rating,
isnull(round(avg(review_scores_value),1),0) as avg_review_scores_value,
month(date) as months,count(c.id) as bookings_per_month,host_is_superhost
from host_vancouver_df as a join listing_vancouver_df b on a.host_id=b.host_id join review_vancouver_df as c on b.id=c.listing_id
where host_location like 'vancouver%'
group by a.host_id, host_name,substring(host_location,0,charindex(',',host_location,1))
,host_is_superhost,host_has_profile_pic,host_identity_verified,month(date)
order by host_is_superhost,months

---q.b.vancouver


select host_is_superhost,substring(host_location,0,charindex(',',host_location,1)) host_location,round(isnull(avg(review_scores_rating),0),1) as avg_review_scores_rating,
round(isnull(avg(review_scores_cleanliness),0),1) as avg_review_scores_cleanliness,round(avg(price),1) as avg_price
from host_vancouver_df as a  
join listing_vancouver_df as b on a.host_id=b.host_id 
where host_location like 'vancouver%'
group by host_is_superhost,substring(host_location,0,charindex(',',host_location,1))
order by host_is_superhost desc

---q.c.vancouver

select top 10 host_is_superhost,host_location,reviewer_name,substring(comments,1,charindex('.',comments,1)) as comments 
from host_vancouver_df as a  join listing_vancouver_df as b on a.host_id=b.host_id join review_vancouver_df as c
on b.id=c.listing_id
where host_is_superhost like 'TRUE'

union

select top 10 host_is_superhost,host_location,reviewer_name,substring(comments,1,charindex('.',comments,1)) as comments 
from host_vancouver_df as a  join listing_vancouver_df as b on a.host_id=b.host_id join review_vancouver_df as c
on b.id=c.listing_id
where host_is_superhost like 'FALSE' 

---q.d-vancouver

select host_is_superhost,host_location,property_type,count(b.host_id) as count_of_people 
from host_vancouver_df as a  join listing_vancouver_df as b on a.host_id=b.host_id 
where host_location like 'vancouver%' 
group by host_is_superhost,host_location,property_type
order by property_type

---q.d.vancouver
select * from
(select * , dense_rank() over (partition by host_is_superhost order by total_properties_types desc) ranking from
(select ht.host_id , host_name ,substring(host_location,0,charindex(',',host_location,1)) host_location,host_is_superhost,
count( property_type) total_properties_types from host_vancouver_df ht
join listing_vancouver_df lt
on ht.host_id = lt.host_id
where host_location like 'vancouver%'
group by ht.host_id , host_name ,host_location,host_is_superhost) a) b
where ranking <= 5


---Q.E-
SELECT	HOST_IS_superhost ,substring(host_location,0,charindex(',',host_location,1)) as host_location
, round(avg(review_scores_communication),2) as avg_review_scores_communication
from host_vancouver_df a join listing_vancouver_df b on a.host_id=b.host_id
where host_location like 'vancouver%'
group by host_is_superhost,host_location


