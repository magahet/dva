# Activity: Time Series Analysis
# GID: mmendiola3

library(zoo)  # basic time series package
library(xts)  # eXtensible Time Series package

data_dir <- "data"
label_dir <- "labeled_windows"

load_ts <- function(csv_filename) {
    # Load and return time series data from a CSV file.
    #
    # Params:
    # - csv_filename: CSV file with two columns: timestamp, value
    #
    # Returns:
    # - s: time series data of type xts

    df <- read.csv(csv_filename, stringsAsFactors=FALSE)
    
    # TODO: convert timestamp column to POSIX datetime
    
    df$timestamp <- as.POSIXct(df$timestamp)  # convert to POSIX datetime
    
    # TODO: create xts time series from dataframe
    
    s <- xts(df$value, order.by=df$timestamp)  # convert to POSIX datetime
    names(s) <- c('value')
    
    return(s)  # return time series
}

find_anomalies <- function(s, window_size=11, threshold=4) {
    # Find anomalous data points in a time series.
    #
    # Params:
    # - s: time series data, as returned by load_ts()
    # - window_size: size of window used to compute rolling statistics
    # - threshold: parameter used to identify outliers
    #
    # Returns: A list with the following named items:
    # - s [input]
    # - window_size [input]
    # - threshold [input]
    # - s.mean: rolling mean
    # - s.sd: rolling standard deviation (s.d.)
    # - anomalies: anomalous data points, as a subset of s

    # TODO: Compute rolling mean
    # Hint: use rollapply() with align = 'right' and fill = 'extend'
    s.mean <- rollapply(s, window_size, mean, align = 'right', fill = 'extend')
    
    # TODO: Compute rolling standard deviation
    s.sd <- rollapply(s, window_size, sd, align = 'right', fill = 'extend')
    
    # TODO: Find anomalies
    # Hint: Look for data points that are more than (threshold * s.d.) away from mean
    lower <- s.mean - threshold * s.sd
    upper <- s.mean + threshold * s.sd
    s.anomalies <- s > upper | s < lower
    anomalies <- s[s.anomalies]

    # TODO: Filter anomalies to only keep extrema
    # Hint: Look for peaks and troughs
    s.max <- rollapply(s, window_size, max, fill='extend')
    s.min <- rollapply(s, window_size, min, fill='extend')
    extrema <- s == s.max | s == s.min 
    anomalies <- s[s.anomalies & extrema]
    

    # TODO(optional): Further filtering to reduce duplicates and false positives

    # Return results as a named list (include input params as well)
    return(list(s=s, window_size=window_size, threshold=threshold,
                s.mean=s.mean, s.sd=s.sd, anomalies=anomalies))
}

analyze <- function(csv_filename, window_days=3, threshold=4) {
    # Analyze a time series, looking for anomalies.
    #
    # Params:
    # - csv_filename: CSV file with two columns: timestamp, value
    # - window_days: no. of days to include in moving window
    # - threshold: parameter passed on to find_anomalies()
    #
    # Returns:
    # - s: results returned by find_anomalies()

    s <- load_ts(csv_filename)  # load time series data from CSV file

    # Compute samples per day to set rolling window size
    avg_delta <- difftime(index(s)[length(s)], index(s)[1], units='secs') / length(s)
    samples_per_day <- 24 * 60 * 60 / as.numeric(avg_delta)
    window_size <- as.integer(window_days * samples_per_day)  # no. of days * samples_per_day

    # Find anomalies
    res <- find_anomalies(s, window_size, threshold)
    cat(paste(csv_filename, ": window_size = ", window_size, ", threshold = ", threshold, sep=""), end="\n")
    cat(length(res$anomalies), "anomalies found", end="\n")
    #print(res$anomalies)

    # Pass on results returned by find_anomalies()
    return(res)
}

visualize <- function(res, wins=NA, title="Anomaly Detection Results") {
    # Visualize the results of anomaly detection.
    #
    # Params:
    # - res: anomaly detection results, as returned by find_anomalies()
    # - wins: optional windows to be highlighted
    # - title: main title for the plot
    #
    # Returns: Nothing

    # Plot original time series, with optional highlight windows
    if(!is.na(wins) && nrow(wins) > 0) {
        plot(res$s, type="n", main=title)  # create a blank plot first
        rect(wins$beg, min(res$s), wins$end, max(res$s), col="#CCCCEE77", border=NA)  # add highlights
        lines(res$s)  # then draw the time series
    } else {
        plot(res$s, main=title)
    }
    
    # TODO: Show moving average
    lines(res$s.mean, type='l', col='green')
    
    # TODO: Draw margins at mean +/- (threshold * s.d.)
    lines(res$s.mean + res$threshold * res$s.sd, type='l', col='red')
    lines(res$s.mean - res$threshold * res$s.sd, type='l', col='red')
    
    # TODO: Mark anomalies
    points(res$anomalies)
}

# NOTE: Do not put any code outside the functions or the following "main" block
if(getOption("run.main", default=TRUE)) {
    # Analyze
    test_cases <- rbind.data.frame(
      # data.frame(csv_filename = "realAWSCloudwatch/ec2_cpu_utilization_5f5533.csv", window_size = 800, threshold = 3.5),
      # data.frame(csv_filename = "realAWSCloudwatch/ec2_network_in_257a54.csv", window_size = 1200, threshold = 8),
      # data.frame(csv_filename = "realTraffic/speed_6005.csv", window_size = 800, threshold = 6.5)
      data.frame(csv_filename = "realAWSCloudwatch/ec2_network_in_257a54.csv", window_size = 1200, threshold = 8)
    )
    for(t in 1:nrow(test_cases)) {
      # Prepare test case
      csv_filename <- test_cases$csv_filename[[t]]
      window_size <- test_cases$window_size[[t]]
      threshold <- test_cases$threshold[[t]]
      s <- load_ts(paste(data_dir, csv_filename, sep="/"))  # load data (will fail if load_ts isn't good)
      res <- find_anomalies(s, window_size=window_size, threshold=threshold)
  
      # Visualize (with ground truth windows highlighted)
      wins <- read.csv(paste(label_dir, csv_filename, sep="/"), stringsAsFactors=FALSE)  # ground truth windows
      wins$beg <- as.POSIXct(wins$beg)  # convert to POSIX datetime
      wins$end <- as.POSIXct(wins$end)
      visualize(res, wins=wins, title=paste("Anomaly Detection Results", csv_filename, sep="\n"))
    }
}
