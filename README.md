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

#### Additional questions
- Q: какой из ключей интересующий нас в задаче прайс? (price(USD) - всегда пуст)
- A: прайс - это price(USD) там есть часть старых данных, если проскролить ниже, далее price(USD) не пуст, поэтому, там где null либо оставить null либо null = 0
- Q: Based on granularity, date should be the first day of week, month, etc еслси во входных параметрах запроса дата не есть первой датой периода
  1 Выкидывать ошибку
  2 Определять дату начала периода
  3 Считать как есть
  например For example if granularity is weekly - price should be calculated as price_sum_for_week / 7. дата приходит сред - а мы считаем с понедельника, мы считаем со среды + 7 дней, мы считаем со среды до воскресенья или выводим ошибку даты? Второе с этого же обьяснения -  price_sum_for_week / 7 если теоретически данные у нас не полные, и нет каких-то дней среднее считать все равно по какому-то параметру 7 дней для недели, количество дней в месяце или использовать длину записей группированого периода? Например записи в группе за неделю есть только за 5 дней недели делиим на 5"
- A: считать как есть, если в месяце 5 дней, то цену делим на 5.

### Solution
- bundle install
- run app `bundle exec ruby ./lib/awesome_module.rb 2009-01-1 2021-12-31 by_date`
- tests `bundle exec rspec`
