/* # of Distinct Campaigns */ 
SELECT COUNT(DISTINCT utm_campaign) AS 'Campaign'
FROM page_visits;

/* # of Distinct Sources */
SELECT COUNT(DISTINCT utm_source) AS 'Source'
FROM page_visits;

/* Sources by Campaign */
SELECT utm_campaign AS 'Campaign',
	utm_source AS 'Source'
FROM page_visits
GROUP BY utm_campaign;

/* Page Names */
SELECT DISTINCT page_name AS 'Page Name'
FROM page_visits
GROUP BY page_name; 

/* Temp Table of First Touch by User ID used to determine First Touch by Campaign */
WITH ft AS (
    SELECT user_id,
  			utm_campaign AS 'Campaign',
        MIN(timestamp) AS 'First_touch'
    FROM page_visits
    GROUP BY user_id)
SELECT Campaign,
    COUNT(First_touch) AS '# of First Touches'
FROM ft
JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.First_touch = pv.timestamp
GROUP BY Campaign;

/* Temp Table of Last Touch by User ID Used to determine Last Touch by Campaign */
WITH lt AS (
    SELECT user_id,
  	utm_campaign AS 'Campaign',
        MAX(timestamp) AS 'Last_touch'
    FROM page_visits
    GROUP BY user_id)
SELECT Campaign,
    COUNT(Last_touch) AS '# of Last Touches'
FROM lt
JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.Last_touch = pv.timestamp
GROUP BY Campaign;

/* Number of Site Visitors */
SELECT COUNT(DISTINCT user_id) AS '# of Visitors'
FROM page_visits;

/* Number of Site Visitors who Purchase */
SELECT COUNT (DISTINCT user_id) AS '# of Purchasers'
FROM page_visits
WHERE page_name IS '4 - purchase';

/* Temp Table of Last Touch by User ID Used to determine Last Touch on Purchase Page by Campaign */
WITH lt AS (
	SELECT user_id,
		utm_campaign AS 'Campaign',
		MAX(timestamp) AS 'Last_touch'
  FROM page_visits
  GROUP BY user_id)
SELECT Campaign,
	COUNT(Last_touch) AS '# of Last Touches'
FROM lt
JOIN page_visits pv
	ON lt.user_id = pv.user_id
  AND lt.Last_touch = pv.timestamp
WHERE page_name IS '4 - purchase'
GROUP BY Campaign; 	
  
/*** EXTRA ***/