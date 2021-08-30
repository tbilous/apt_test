### Requirements

- Please submit your solutions via email as a single zip or tgz package. Github repos, files shared via dropbox, etc will not be
accepted.
- Problem: Bitcoin Time Series Filtering and Grouping
Please, implement a method (function) or a class that will parse this json data. You can use either Ruby or EcmaScript
language to implement this task. As a result this method should return an array with the following structure:
[[date, price], [date, price], ...]
- Records should be in descending order by default. Input parameters should be:
  - order_dir - desc, asc (desc by default) to order by date
  - filter_date_from - date string or date object, if passed, list should be filtered by this date as a start date
  - filter_date_to - date string or date object, if passed, list should be filtered by this date as an end date
  - granularity - daily (default), weekly, monthly, quarterly. This parameter should group price data by the
  given period. Based on granularity, date should be the first day of week, month, etc. Price in each group should be
  calculated as average value. For example if granularity is weekly - price should be calculated as
  price_sum_for_week / 7.
- Link to the json data:
  https://pkgstore.datahub.io/cryptocurrency/bitcoin/bitcoin_json/data/3d47ebaea5707774cb076c9cd2e0ce8c/bitcoin_json.json
- Also, implement unit tests. Please, use Rspec framework for Ruby tests or Jest framework for EcmaScript tests.
