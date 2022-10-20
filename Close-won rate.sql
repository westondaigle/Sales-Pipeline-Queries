SELECT SUM(ESTIMATED_GMV)
FROM(
select
deal_close_date,
case when account_segment = 'Self-Service' then 'SMB' else account_segment end as account_segment,
case when account_segment in ('Key','Enterprise') then 'Key + Enterprise'
when account_segment = 'New Markets' then 'New Markets'
else 'SMB' end as account_segment_adj,
case when acc.vertical__c in ('Home','Lifestyle','Other','Big Box','Mobile/Devices','Elective Medical','Home Improvement') or acc.vertical__c is null then 'H&L'
when acc.vertical__c = 'Auto' then 'New Markets'
else vertical__c end as vertical,
opportunity_name,
sfdc_account_name,
sum(estimated_gmv_signed) as estimated_gmv,
sum(estimated_revenue_signed) as estimated_revenue,
count(distinct opportunity_id) as num_deals
from PROD__WORKSPACE__US.SCRATCH_t_strategicfinance.fy23_sales_comp_data sd
left join prod__us.salesforce.account acc on sd.sfdc_account_id = acc.id
LEFT JOIN SALESFORCE.RAW_TESTING.OPPORTUNITY o on sd.OPPORTUNITY_ID=o.id
where sd.type = 'opportunities_data'
and deal_close_date >= '2022-07-01' and deal_close_date < '2022-10-01'
and o.Affirm_Business_Unit__c='US'
group by 1,2,3,4,5,6 order by 1,2,3,4,5,6 asc)
