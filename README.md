# Commercial-Database-Analysis
Analyzing the dataset to Generate insights like, Display customers who reside in the same region as supplier 1, meaning they share the same country, city, and the last three digits of the postal code.
---
The query should utilize a single subquery. The resulting table should include all columns from the customer table. For each order number between 10998 and 11003, do the following:   -Display the new discount rate, which should be 0% if the total order amount before discount (unit price * quantity) is between 0 and 2000, 5% if between 2001 and 10000, 10% if between 10001 and 40000, 15% if between 40001 and 80000, and 20% otherwise. -Display the message "apply old discount rate" if the order number is between 10000 and 10999, and "apply new discount rate" otherwise.
---
