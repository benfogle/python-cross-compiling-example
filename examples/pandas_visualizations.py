# Adapted from:
# https://github.com/pandas-dev/pandas/blob/master/doc/source/visualization.rst
# Expected output can be viewed at:
# https://pandas.pydata.org/pandas-docs/stable/visualization.html

import matplotlib.pyplot as plt
import pandas as pd
import numpy as np

import sys
import os

my_dir = os.path.dirname(sys.argv[0])

def savefig(filename):
    print("Saving %s" % filename)
    plt.savefig(filename)

def read_csv(filename):
    path = os.path.join(my_dir, filename)
    return pd.read_csv(path)

np.random.seed(123456)
ts = pd.Series(np.random.randn(1000), index=pd.date_range('1/1/2000', periods=1000))
ts = ts.cumsum()
ts.plot()
savefig('series_plot_basic.png')

plt.close('all')
np.random.seed(123456)
df = pd.DataFrame(np.random.randn(1000, 4), index=ts.index, columns=list('ABCD'))
df = df.cumsum()
plt.figure(); df.plot();
savefig('frame_plot_basic.png')

plt.close('all')
plt.figure()
np.random.seed(123456)
df3 = pd.DataFrame(np.random.randn(1000, 2), columns=['B', 'C']).cumsum()
df3['A'] = pd.Series(list(range(len(df))))
df3.plot(x='A', y='B')
savefig('df_plot_xy.png')

plt.close('all')
plt.figure();
df.iloc[5].plot(kind='bar');
savefig('bar_plot_ex.png')

plt.close('all')
plt.figure();
df.iloc[5].plot.bar(); plt.axhline(0, color='k')
savefig('bar_plot_ex.png')

plt.close('all')
plt.figure()
np.random.seed(123456)
df2 = pd.DataFrame(np.random.rand(10, 4), columns=['a', 'b', 'c', 'd'])
df2.plot.bar();
savefig('bar_plot_multi_ex.png')

plt.close('all')
plt.figure()
savefig('bar_plot_stacked_ex.png')
df2.plot.bar(stacked=True);

plt.close('all')
plt.figure()
df2.plot.barh(stacked=True);
savefig('barh_plot_stacked_ex.png')

df4 = pd.DataFrame({'a': np.random.randn(1000) + 1, 'b': np.random.randn(1000),
                   'c': np.random.randn(1000) - 1}, columns=['a', 'b', 'c'])

plt.figure();
df4.plot.hist(alpha=0.5)
savefig('hist_new.png')

plt.close('all')
plt.figure();
df4.plot.hist(stacked=True, bins=20)
savefig('hist_new_stacked.png')

plt.close('all')
plt.figure();
df4['a'].plot.hist(orientation='horizontal', cumulative=True)
savefig('hist_new_kwargs.png')

plt.close('all')
plt.figure();
df['A'].diff().hist()
savefig('hist_plot_ex.png')

plt.close('all')
plt.figure()
df.diff().hist(color='k', alpha=0.5, bins=50)
savefig('frame_hist_ex.png')

plt.close('all')
plt.figure()
np.random.seed(123456)
data = pd.Series(np.random.randn(1000))
data.hist(by=np.random.randint(0, 4, 1000), figsize=(6, 4))
savefig('grouped_hist.png')

plt.close('all')
np.random.seed(123456)
df = pd.DataFrame(np.random.rand(10, 5), columns=['A', 'B', 'C', 'D', 'E'])
df.plot.box()
savefig('box_plot_new.png')

color = dict(boxes='DarkGreen', whiskers='DarkOrange',
            medians='DarkBlue', caps='Gray')
df.plot.box(color=color, sym='r+')
savefig('box_new_colorize.png')

plt.close('all')
df.plot.box(vert=False, positions=[1, 4, 5, 6, 8])
savefig('box_new_kwargs.png')


plt.close('all')
np.random.seed(123456)
df = pd.DataFrame(np.random.rand(10,5))
plt.figure();
bp = df.boxplot()
savefig('box_plot_ex.png')

plt.close('all')
np.random.seed(123456)
df = pd.DataFrame(np.random.rand(10,2), columns=['Col1', 'Col2'] )
df['X'] = pd.Series(['A','A','A','A','A','B','B','B','B','B'])
plt.figure();
bp = df.boxplot(by='X')
savefig('box_plot_ex2.png')

plt.close('all')
np.random.seed(123456)
df = pd.DataFrame(np.random.rand(10,3), columns=['Col1', 'Col2', 'Col3'])
df['X'] = pd.Series(['A','A','A','A','A','B','B','B','B','B'])
df['Y'] = pd.Series(['A','B','A','B','A','B','A','B','A','B'])
plt.figure();
bp = df.boxplot(column=['Col1','Col2'], by=['X','Y'])
savefig('box_plot_ex3.png')

plt.close('all')
np.random.seed(1234)
df_box = pd.DataFrame(np.random.randn(50, 2))
df_box['g'] = np.random.choice(['A', 'B'], size=50)
df_box.loc[df_box['g'] == 'B', 1] += 3
bp = df_box.boxplot(by='g')
savefig('boxplot_groupby.png')

plt.close('all')
bp = df_box.groupby('g').boxplot()
savefig('groupby_boxplot_vis.png')

plt.close('all')
np.random.seed(123456)
plt.figure()

df = pd.DataFrame(np.random.rand(10, 4), columns=['a', 'b', 'c', 'd'])
df.plot.area();
savefig('area_plot_stacked.png')

plt.close('all')
plt.figure()
df.plot.area(stacked=False);
savefig('area_plot_unstacked.png')

np.random.seed(123456)
plt.close('all')
plt.figure()
df = pd.DataFrame(np.random.rand(50, 4), columns=['a', 'b', 'c', 'd'])
df.plot.scatter(x='a', y='b');
savefig('scatter_plot.png')

ax = df.plot.scatter(x='a', y='b', color='DarkBlue', label='Group 1');
df.plot.scatter(x='c', y='d', color='DarkGreen', label='Group 2', ax=ax);
savefig('scatter_plot_repeated.png')

plt.close('all')
df.plot.scatter(x='a', y='b', c='c', s=50);
savefig('scatter_plot_colored.png')

plt.close('all')
df.plot.scatter(x='a', y='b', s=df['c']*200);
savefig('scatter_plot_bubble.png')

plt.close('all')
plt.figure()
np.random.seed(123456)
df = pd.DataFrame(np.random.randn(1000, 2), columns=['a', 'b'])
df['b'] = df['b'] + np.arange(1000)
df.plot.hexbin(x='a', y='b', gridsize=25)
savefig('hexbin_plot.png')

plt.close('all')
plt.figure()
np.random.seed(123456)
df = pd.DataFrame(np.random.randn(1000, 2), columns=['a', 'b'])
df['b'] = df['b'] = df['b'] + np.arange(1000)
df['z'] = np.random.uniform(0, 3, 1000)
df.plot.hexbin(x='a', y='b', C='z', reduce_C_function=np.max,
       gridsize=25)
savefig('hexbin_plot_agg.png')

plt.close('all')
np.random.seed(123456)
plt.figure()
series = pd.Series(3 * np.random.rand(4), index=['a', 'b', 'c', 'd'], name='series')
series.plot.pie(figsize=(6, 6))
savefig('series_pie_plot.png')

plt.close('all')
np.random.seed(123456)
plt.figure()
df = pd.DataFrame(3 * np.random.rand(4, 2), index=['a', 'b', 'c', 'd'], columns=['x', 'y'])
df.plot.pie(subplots=True, figsize=(8, 4))
savefig('df_pie_plot.png')

plt.close('all')
plt.figure()
series.plot.pie(labels=['AA', 'BB', 'CC', 'DD'], colors=['r', 'g', 'b', 'c'],
               autopct='%.2f', fontsize=20, figsize=(6, 6))
savefig('series_pie_plot_options.png')

plt.close('all')
plt.figure()
series = pd.Series([0.1] * 4, index=['a', 'b', 'c', 'd'], name='series2')
series.plot.pie(figsize=(6, 6))
savefig('series_pie_plot_semi.png')

# Needs scipy
#plt.close('all')
#np.random.seed(123456)
#from pandas.plotting import scatter_matrix
#df = pd.DataFrame(np.random.randn(1000, 4), columns=['a', 'b', 'c', 'd'])
#scatter_matrix(df, alpha=0.2, figsize=(6, 6), diagonal='kde')
#plt.savefig('scatter_matrix_kde.png')
#
#plt.close('all')
#plt.figure()
#np.random.seed(123456)
#ser = pd.Series(np.random.randn(1000))
#ser.plot.kde()
#savefig('kde_plot.png')

plt.close('all')
from pandas.plotting import andrews_curves
data = read_csv('data/iris.csv')
plt.figure()
andrews_curves(data, 'Name')
savefig('andrews_curves.png')

from pandas.plotting import parallel_coordinates
data = read_csv('data/iris.csv')
plt.figure()
parallel_coordinates(data, 'Name')
savefig('parallel_coordinates.png')

plt.close('all')
np.random.seed(123456)
from pandas.plotting import lag_plot
plt.figure()
data = pd.Series(0.1 * np.random.rand(1000) +
   0.9 * np.sin(np.linspace(-99 * np.pi, 99 * np.pi, num=1000)))
lag_plot(data)
savefig('lag_plot.png')

plt.close('all')
np.random.seed(123456)
from pandas.plotting import autocorrelation_plot
plt.figure()
data = pd.Series(0.7 * np.random.rand(1000) +
  0.3 * np.sin(np.linspace(-9 * np.pi, 9 * np.pi, num=1000)))
autocorrelation_plot(data)
savefig('autocorrelation_plot.png')

plt.close('all')
np.random.seed(123456)
from pandas.plotting import bootstrap_plot
data = pd.Series(np.random.rand(1000))
bootstrap_plot(data, size=50, samples=500, color='grey')
savefig('bootstrap_plot.png')

plt.close('all')
from pandas.plotting import radviz
data = read_csv('data/iris.csv')
plt.figure()
radviz(data, 'Name')
savefig('radviz.png')

plt.close('all')
plt.figure(); ts.plot(style='k--', label='Series');
savefig('series_plot_basic2.png')

plt.close('all')
np.random.seed(123456)
df = pd.DataFrame(np.random.randn(1000, 4), index=ts.index, columns=list('ABCD'))
df = df.cumsum()
df.plot(legend=False)
savefig('frame_plot_basic_noleg.png')

plt.close('all')
plt.figure()
np.random.seed(123456)
ts = pd.Series(np.random.randn(1000), index=pd.date_range('1/1/2000', periods=1000))
ts = np.exp(ts.cumsum())
ts.plot(logy=True)
savefig('series_plot_logy.png')

plt.close('all')
plt.figure()
df.A.plot()
df.B.plot(secondary_y=True, style='g')
savefig('series_plot_secondary_y.png')

plt.close('all')
plt.figure()
ax = df.plot(secondary_y=['A', 'B'])
ax.set_ylabel('CD scale')
ax.right_ax.set_ylabel('AB scale')
savefig('frame_plot_secondary_y.png')

plt.close('all')
plt.figure()
df.plot(secondary_y=['A', 'B'], mark_right=False)
savefig('frame_plot_secondary_y_no_right.png')

plt.close('all')
plt.figure()
df.A.plot()
savefig('ser_plot_suppress.png')

plt.close('all')
plt.figure()
df.A.plot(x_compat=True)
savefig('ser_plot_suppress_parm.png')

plt.close('all')
plt.figure()
with pd.plotting.plot_params.use('x_compat', True):
   df.A.plot(color='r')
   df.B.plot(color='g')
   df.C.plot(color='b')
savefig('ser_plot_suppress_context.png')

plt.close('all')
df.plot(subplots=True, figsize=(6, 6));
savefig('frame_plot_subplots.png')

plt.close('all')
df.plot(subplots=True, layout=(2, 3), figsize=(6, 6), sharex=False);
savefig('frame_plot_subplots_layout.png')

plt.close('all')
fig, axes = plt.subplots(4, 4, figsize=(6, 6));
plt.subplots_adjust(wspace=0.5, hspace=0.5);
target1 = [axes[0][0], axes[1][1], axes[2][2], axes[3][3]]
target2 = [axes[3][0], axes[2][1], axes[1][2], axes[0][3]]

df.plot(subplots=True, ax=target1, legend=False, sharex=False, sharey=False);
(-df).plot(subplots=True, ax=target2, legend=False, sharex=False, sharey=False);
savefig('frame_plot_subplots_multi_ax.png')

plt.close('all')
np.random.seed(123456)
ts = pd.Series(np.random.randn(1000), index=pd.date_range('1/1/2000', periods=1000))
ts = ts.cumsum()
df = pd.DataFrame(np.random.randn(1000, 4), index=ts.index, columns=list('ABCD'))
df = df.cumsum()
plt.close('all')

fig, axes = plt.subplots(nrows=2, ncols=2)
df['A'].plot(ax=axes[0,0]); axes[0,0].set_title('A');
df['B'].plot(ax=axes[0,1]); axes[0,1].set_title('B');
df['C'].plot(ax=axes[1,0]); axes[1,0].set_title('C');
df['D'].plot(ax=axes[1,1]); axes[1,1].set_title('D');
savefig('series_plot_multi.png')

plt.close('all')
# Generate the data
ix3 = pd.MultiIndex.from_arrays([['a', 'a', 'a', 'a', 'b', 'b', 'b', 'b'], ['foo', 'foo', 'bar', 'bar', 'foo', 'foo', 'bar', 'bar']], names=['letter', 'word'])
df3 = pd.DataFrame({'data1': [3, 2, 4, 3, 2, 4, 3, 2], 'data2': [6, 5, 7, 5, 4, 5, 6, 5]}, index=ix3)

# Group by index labels and take the means and standard deviations for each group
gp3 = df3.groupby(level=('letter', 'word'))
means = gp3.mean()
errors = gp3.std()
means
errors

# Plot
fig, ax = plt.subplots()
means.plot.bar(yerr=errors, ax=ax)
savefig('errorbar_example.png')

plt.close('all')
np.random.seed(123456)
fig, ax = plt.subplots(1, 1)
df = pd.DataFrame(np.random.rand(5, 3), columns=['a', 'b', 'c'])
ax.get_xaxis().set_visible(False)   # Hide Ticks
df.plot(table=True, ax=ax)
savefig('line_plot_table_true.png')

plt.close('all')
fig, ax = plt.subplots(1, 1)
ax.get_xaxis().set_visible(False)   # Hide Ticks
df.plot(table=np.round(df.T, 2), ax=ax)
savefig('line_plot_table_data.png')

plt.close('all')
from pandas.plotting import table
fig, ax = plt.subplots(1, 1)

table(ax, np.round(df.describe(), 2),
     loc='upper right', colWidths=[0.2, 0.2, 0.2])

df.plot(ax=ax, ylim=(0, 2), legend=None)
savefig('line_plot_table_describe.png')

plt.close('all')
np.random.seed(123456)
df = pd.DataFrame(np.random.randn(1000, 10), index=ts.index)
df = df.cumsum()
plt.figure()
df.plot(colormap='cubehelix')
savefig('cubehelix.png')

plt.close('all')
from matplotlib import cm
plt.figure()
df.plot(colormap=cm.cubehelix)
savefig('cubehelix_cm.png')

plt.close('all')
np.random.seed(123456)
dd = pd.DataFrame(np.random.randn(10, 10)).applymap(abs)
dd = dd.cumsum()
plt.figure()
dd.plot.bar(colormap='Greens')
savefig('greens.png')

plt.close('all')
plt.figure()
parallel_coordinates(data, 'Name', colormap='gist_rainbow')
savefig('parallel_gist_rainbow.png')

plt.close('all')
plt.figure()
andrews_curves(data, 'Name', colormap='winter')
savefig('andrews_curve_winter.png')

plt.close('all')
np.random.seed(123456)
price = pd.Series(np.random.randn(150).cumsum(),
                 index=pd.date_range('2000-1-1', periods=150, freq='B'))
ma = price.rolling(20).mean()
mstd = price.rolling(20).std()

plt.figure()

plt.plot(price.index, price, 'k')
plt.plot(ma.index, ma, 'b')
plt.fill_between(mstd.index, ma-2*mstd, ma+2*mstd, color='b', alpha=0.2)
savefig('bollinger.png')

plt.close('all')
