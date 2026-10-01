# Food Delivery SQL Analysis

## 1. Operations Insights

### longest delivery time by city_tier
Finding:3	94.3325797872340426
        1	94.1732473811442385
        2	93.7186585041256322
Means 3rd tier city take longest delivery time

### Traffic_level vs Delivery_time
Finding:traffic_level  orders  avg_delivery_time
            1	        2910	86.00
            2	        1504	88.62
            3	        1497	93.71
            4	        1548	93.13
            5	        1508	94.71
            6	        1481	96.22
            7	        1467	97.90
            8	        1494	101.45
            9	        1506	102.90
            10	        85	    101.55
Higher Traffic Level means take more time for delivery

### Distance vs Delivery Time
Finding:                orders  avg_delivery_time
        "0-5 km"    	1865	49.98
        "5-10 km"   	1831	62.76
        "10-15 km"  	1894	74.54
        "15+ km"    	9410	112.94
long distance means higher delivery time


### preparation time vs delays
Finding:"0-10 min"	1305	0.26
        "30+ min"	8418	0.08
        "10-20 min"	2635	-0.17
        "20-30 min"	2642	-0.22
preparation time not effecting the delays
because when we have 20-30 preparation slab, difference of actual delivery time and estimated time is negative means delivery done faster comapare to estimated.
also when preparation time less still we got positive difference means actual delivery time is higher than estimated.

### reason for poor delivery efficiency score    status         orders  distance  traffic_score avg_p_time  avg_d_time
                                                "Poor"	        4687	28.76	  6.43	        37.90	    125.92
                                                "Excellent"	    689	    6.70	  2.51	        22.21	    40.05
here poor show low efficiency below 50 out of 100. 
compare to excellence, avg distance is high, traffice score high, delivery time high and preparation time high. 
these condition leads towards poor delivery efficiency score.



### 2. Customer Insights

### Premium customer vs orders value
Finding:        orders  avg_final_amount_value  avg_order_value
"non premium"	10779	115.2793320345115502	110.1634103349104741
"premium"	    4221	128.7987799099739398	123.6347855958303719

premium customer have high spend on orders

### loyality-> spending(order_value)
Finding:            orders  avg_amount      avg_order_value
"High Loyalty"	    4524	119.62	        114.60
"Medium Loyalty"	4429	118.97	        113.94
"Low Loyalty"	    6047	118.76	        113.47
loyality score more than 70 show high order value
               below 70 show low order compare to high
               below 50 is low loyality have lowest order value

### Customer Age -> orders
Finding:            revenue     orders   avg_order_value
"Middle-age"(36-56)	647541.82	5418	114.1170893318567737
"senior"(56+)	    584851.44	4931	113.6858933279253701
"young"(18-36)      553862.31	4651	114.0490862180176306

### discount-> customer spending
Finding:                        orders  discount_amount          order_value            final_amount
"no discount(0)"	             7	    0.00000000000000000000	108.7700000000000000	128.2542857142857143
"high discount(20+)"	        5515	22.6703934723481414 	114.3590335448776065	111.6978640072529465
"small discount(1-10)"	        4503	5.4495092160781701	    114.1853053519875638	128.8319498112369531
"medium discount(10-20)"	    4975	14.9592844221105528	    113.3037065326633166	118.4349346733668342


## 3.BUSINESS INSIGHTS

### cancellation Rate
Finding:           15000	2003	13.35  
        out of 15000 order, 2003 are cancelled which rating 13.25%

### Refund Rate
Finding:       15000	618	  4.12
        out of 15000 order, 618 have refund which rating 4.12%

### weekend/festival -> orders
Finding:                    orders
"Non-Weekend / Weekday"  	11913
"Weekend / Festival"	    3087

## 4. Key Business Findings

1. Higher Traffic leads to poor Delivery ( increase delivery time )
2. almost 66% order comes from Middle age and young Customers
3. redund rate and cancellation rate is lower
4. weekday contain higher orders
5. Distance, Traffic, delivery time: factors lead towards poor delivery efficiency score