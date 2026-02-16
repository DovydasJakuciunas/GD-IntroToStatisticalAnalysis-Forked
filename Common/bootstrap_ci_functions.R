# ----------------------------
# Bootstrap CI helper functions
# ----------------------------

bootstrap_ci_mean <- function(x, n_boot = 5000, conf_level = 0.95, seed = 123)
{
  # Returns a list with mean estimate and percentile CI.
  # x: numeric vector (can include NA).
  x <- x[!is.na(x)]
  if (length(x) < 2)
    stop("Need at least 2 non-missing values for a CI.")
  
  set.seed(seed)
  
  n <- length(x)
  boot_means <- numeric(n_boot)
  
  for (i in seq_len(n_boot))
    boot_means[i] <- mean(sample(x, size = n, replace = TRUE))
  
  alpha <- (1 - conf_level) / 2
  ci <- quantile(boot_means, probs = c(alpha, 1 - alpha), names = FALSE)
  
  list(
    estimate = mean(x),
    ci_low = ci[1],
    ci_high = ci[2],
    n = n,
    n_boot = n_boot
  )
}

bootstrap_ci_mean_diff <- function(x_a, x_b, n_boot = 5000, conf_level = 0.95, seed = 123)
{
  # Returns CI for mean(B) - mean(A).
  x_a <- x_a[!is.na(x_a)]
  x_b <- x_b[!is.na(x_b)]
  
  if (length(x_a) < 2 || length(x_b) < 2)
    stop("Need at least 2 non-missing values in each group for a CI.")
  
  set.seed(seed)
  
  n_a <- length(x_a)
  n_b <- length(x_b)
  
  boot_diffs <- numeric(n_boot)
  
  for (i in seq_len(n_boot))
  {
    mean_a <- mean(sample(x_a, size = n_a, replace = TRUE))
    mean_b <- mean(sample(x_b, size = n_b, replace = TRUE))
    boot_diffs[i] <- mean_b - mean_a
  }
  
  alpha <- (1 - conf_level) / 2
  ci <- quantile(boot_diffs, probs = c(alpha, 1 - alpha), names = FALSE)
  
  list(
    estimate = mean(x_b) - mean(x_a),
    ci_low = ci[1],
    ci_high = ci[2],
    n_a = n_a,
    n_b = n_b,
    n_boot = n_boot
  )
}

bootstrap_ci_rate_diff <- function(y_a, y_b, n_boot = 5000, conf_level = 0.95, seed = 123)
{
  # Returns CI for rate(B) - rate(A) where y is 0/1.
  y_a <- y_a[!is.na(y_a)]
  y_b <- y_b[!is.na(y_b)]
  
  if (length(y_a) < 2 || length(y_b) < 2)
    stop("Need at least 2 non-missing values in each group for a CI.")
  
  if (!all(y_a %in% c(0, 1)) || !all(y_b %in% c(0, 1)))
    stop("Rate CI expects 0/1 data (binary).")
  
  set.seed(seed)
  
  n_a <- length(y_a)
  n_b <- length(y_b)
  
  boot_diffs <- numeric(n_boot)
  
  for (i in seq_len(n_boot))
  {
    rate_a <- mean(sample(y_a, size = n_a, replace = TRUE))
    rate_b <- mean(sample(y_b, size = n_b, replace = TRUE))
    boot_diffs[i] <- rate_b - rate_a
  }
  
  alpha <- (1 - conf_level) / 2
  ci <- quantile(boot_diffs, probs = c(alpha, 1 - alpha), names = FALSE)
  
  list(
    estimate = mean(y_b) - mean(y_a),
    ci_low = ci[1],
    ci_high = ci[2],
    n_a = n_a,
    n_b = n_b,
    n_boot = n_boot
  )
}