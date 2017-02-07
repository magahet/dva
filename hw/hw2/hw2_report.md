% HW2: Data Visualization - CSE 6242
% mmendiola3



# 1. Professional Employment by State

Figure \ref{percprof} shows the percentage of each state's adult population with professional employment. This shows that IL has the highest percentage at 7.5%, while WI has the lowest at 5.6%.

![percprof\label{percprof}](fig/percprof.png)



# 2. School and College Education by State

## Relationship between HS diploma % and College diploma %

![college_hsd\label{college_hsd}](fig/college_hsd.png)

Figure \ref{college_hsd} shows the relationship between the percentage of each county's adult population with a high school diploma and the percentage of those with a college diploma. Visually, we can observe a positive correlation in total and as well as for counties within each state. The correlation coefficient is 0.78 across the full dataset.

## Relationship between HS diploma and state

![hsd_box\label{hsd_box}](fig/hsd_box.png)

The distribution of high school diploma percentages within each state is shown in Figure \ref{hsd_box}. We see that IL has the lowest median, WI has the highest, and each state has a similar distribution of values across their counties. OH seem to have some counties with significantly lower values (<25%).

![hsd_bar\label{hsd_bar}](fig/hsd_bar.png)

Figure \ref{hsd_bar} shows the data aggregated at the state level. This view shows us much less information and makes each state's high school diploma percentages almost equal (all between 75% and 79%). Here WI has the highest overall value (78.6%) and IN the lowest (75.6%)

## Relationship between College diploma and state

![college_box\label{college_box}](fig/college_box.png)

The distribution of college diploma percentages within each state is shown in Figure \ref{college_box}. OH has the lowest median (~16%) and WI has the highest (~19%). Each state has many outlier counties with significantly higher values (between 30% and 50%).

![college_bar\label{college_bar}](fig/college_bar.png)

Figure \ref{college_bar} shows the data aggregated at the state level. IL has the highest overall value (27%) and IN the lowest (21%). Comparing the aggregated values to the distributions shows that the outlier values pull the aggregated college percentages up significantly.



# 3. Comparison of Visualization Techniques

## Box Plot elements and relationship to size of a dataset

Box plots have the following elements:

- The IQR box shows the interval between the first and third quartiles. This shows where 50% of the data lays.
- The median line shows the point where half the data points are above and the other half are below.
- The whiskers show the range of values within the dataset. These lines are limited to 1.5x the length of the IQR.
- Outliers are points that fall outside the range of the whiskers.

We can observe from Figure \ref{box_norm} how sample size affects each of these elements. Both plots use random data sampled from a normal distribution with a mean of 0 and a standard deviation of 1. The left-hand plot has a sample size of 100 and the other a sample size of 100,000. The first IQR and median are slightly skewed. This can be attributed to not having enough samples to smooth out the distribution. In contrast, the plot with the larger sample size is symmetric. The whiskers also differ as the range of values within the smaller sample all fall within 1.5 times the IQR length from the IQR box. The larger sample has a large number of outliers. Based on the definition of outliers for this plot type, we can expect to see this for normally distributed data. As we increase sample sizes, we're more likely to see values that lay outside the whiskers.

An observation from this experiment is that small sample sizes could lead to overestimating the importance of each point, thereby losing the reliability in showing the data's distribution. Conversely, too many data points can cause the plot to be overloaded with what it considers to be outliers; Even if these points contribute to the underlying distribution.

# Pros and cons of a Box Plot and a Histogram

Histograms are good for visualizing the distribution of values in a data set. This is especially helpful if the distribution is multi-modal. However, they do not make it easy to get summary information about the distribution. Box plots allow one to see distribution parameters (median, range, percentiles, and outliers). This is helpful when comparing the distribution of values between multiple data sets. Finally, box plot are better at showing the distributions skew and symmetry, but are not as good at showing the shape of the distribution (to estimate the underlying distribution type).

# Data for which to use Histograms, Box Plots, and QQPlots

Histograms are useful for visualizing the data's distribution. This is helpful when trying to gauge the type of underlying distribution the values could match. For example, we could see clearly whether data resembles a bimodal, uniform, or normal distribution, which we could not do with a box plot. As a qq-plot requires that you define the distribution to compare your data against, it is not a good choice when initially trying to identify a distribution.

Box plots are most useful when comparing data distribution statistics between multiple data sets or factors. The data from questions one and two are good examples, as we wanted to observe the differences between the range of values between the various states.

QQ-plots are most appropriate for comparing how the distribution of values compares to another distribution, which may include standard, statistical, distributions. For example, if we wanted to determine if the values in a data set are normally distributed.


# 4. Random Scatterplots


# 5. Diamonds
