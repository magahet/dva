library(GGally)
library(ggplot2)
data(midwest)


# 1. Professional Employment by State

# Using Interpretation A from Piazza

# Get number of professionals in each county from percprof and population of adults
midwest$proftotal = (midwest$percprof / 100) * midwest$popadults

# Group by state, summing the number of professionals and population of adults from each county
agg_by_state <- aggregate(midwest[c('proftotal', 'popadults')], by=list(state=midwest$state), "sum")

# Calculate the percentage of adults in each state with professional employment
agg_by_state$percprof_state = 100 * agg_by_state$proftotal / agg_by_state$popadults

print(agg_by_state)

# Plot percentage of adults with professional employment for each state
# ggplot(data=agg_by_state, aes(x=state, y=percprof_state)) +
#   geom_bar(stat="identity") +
#   ylab('% of state adult population w/ professional employment')


# 2. School and College Education by State

# Plot perchsd against percollege to visualize correlation
# qplot(data=midwest, x=perchsd, y=percollege, color=state)

# Calculate correlation coefficient
cor(midwest$perchsd, midwest$percollege)

# Calculate percentage of adults in each state with a high school diploma. Do the same for college diploma.

midwest$hsdtotal = (midwest$perchsd / 100) * midwest$popadults
midwest$collegetotal = (midwest$percollege / 100) * midwest$popadults
agg_by_state <- aggregate(midwest[c('hsdtotal', 'collegetotal', 'popadults')], by=list(state=midwest$state), "sum")
agg_by_state$perchsd_state = 100 * agg_by_state$hsdtotal / agg_by_state$popadults
agg_by_state$percollege_state = 100 * agg_by_state$collegetotal / agg_by_state$popadults

print(agg_by_state)

ggplot(data=agg_by_state, aes(x=state, y=perchsd_state)) +
  geom_bar(stat="identity") +
  ylab('% of state adult population w/ high school diploma')

ggplot(data=agg_by_state, aes(x=state, y=percollege_state)) +
  geom_bar(stat="identity") +
  ylab('% of state adult population w/ college diploma')

# df <- midwest[c('perchsd', 'percollege', 'state')]
# ggpairs(df[c('perchsd', 'percollege', 'state')])


# 3. Comparison of Visualization Techniques


# 4. Random Scatterplots


# 5. Diamonds