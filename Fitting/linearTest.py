from pymc3 import  *
import numpy as np
import matplotlib.pyplot as plt

#-------------------------------------------------------------------------------
# Generate data:

# size = 200
# true_intercept = 1
# true_slope = 2
#
# x = np.linspace(0, 1, size)
# # y = a + b*x
# true_regression_line = true_intercept + true_slope * x
# # add noise
# y = true_regression_line + np.random.normal(scale=.5, size=size)
#
# data = dict(x=x, y=y)

#-------------------------------------------------------------------------------
# Load data:


#-------------------------------------------------------------------------------
# Plot:
fig = plt.figure(figsize=(7, 7))
ax = fig.add_subplot(111, xlabel='x', ylabel='y', title='Generated data and underlying model')
ax.plot(x, y, 'x', label='sampled data')
ax.plot(x, true_regression_line, label='true regression line', lw=2.)
plt.legend(loc=0);

#-------------------------------------------------------------------------------
# Fitting:
# draw 3000 posterior samples using NUTS sampling
NUM_SAMPLES = 3000
# Use 4 cores:
NUM_CORES = 4

# Model specifications in PyMC3 are wrapped in a with-statement
with Model() as model:
    # Define priors:
    sigma = HalfCauchy('sigma', beta=10, testval=1.)
    intercept = Normal('Intercept', 0, sigma=20)
    x_coeff = Normal('x', 0, sigma=20)

    # Define likelihood:
    likelihood = Normal('y', mu=intercept + x_coeff * x,
                        sigma=sigma, observed=y)

    # Do inference!:
    trace = sample(NUM_SAMPLES, cores=NUM_CORES)

#-------------------------------------------------------------------------------
# Plotting the results:
plt.figure(figsize=(7, 7))
traceplot(trace[100:])
plt.tight_layout();


plt.scatter(trace['Intercept'], trace[varname][:, 1], alpha=.01)

plot_posterior(trace);

#-------------------------------------------------------------------------------
# And more results:
plt.figure(figsize=(7, 7))
plt.plot(x, y, 'x', label='data')
plot_posterior_predictive_glm(trace, samples=100,
                              label='posterior predictive regression lines')
plt.plot(x, true_regression_line, label='true regression line', lw=3., c='y')

plt.title('Posterior predictive regression lines')
plt.legend(loc=0)
plt.xlabel('x')
plt.ylabel('y');
