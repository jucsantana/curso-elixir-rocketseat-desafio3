defmodule ReportGenerator do
  alias GenReport.Parser

  @months [
    "janeiro",
    "fevereiro",
    "março",
    "abril",
    "maio",
    "junho",
    "julho",
    "agosto",
    "setembro",
    "outubro",
    "novembro",
    "dezembro"
  ]

  @names [
    "Cleiton",
    "Daniele",
    "Danilo",
    "Diego",
    "Giuliano",
    "Jakeliny",
    "Joseph",
    "Mayk",
    "Rafael",
    "Vinicius"
  ]

  @years [
    2016,
    2017,
    2018,
    2019,
    2020
  ]

  def call(), do: {:error, "Please, provide a file"}

  def call(filename) do
    filename
    |> Parser.parse_file()
    |> Enum.reduce(report_acc(), fn line, acc -> sum_values(line, acc) end)
  end

  defp sum_values(
         [name, quantity, _day, month, year],
         %{
           "hours_per_month" => hours_per_month,
           "all_hours" => all_hours,
           "hours_per_year" => hours_per_year
         } = acc
       ) do
    %{
      acc
      | "hours_per_month" => sum_hours_per_month(name, quantity, month, hours_per_month),
        "all_hours" => sum_hours_all_hours(name, quantity, all_hours),
        "hours_per_year" => sum_hours_per_year(year, name, hours_per_year, quantity)
    }
  end

  defp sum_hours_per_year(year, name, hours_per_year, quantity) do
    years = hours_per_year[name]
    years_updated = Map.put(years, year, years[year] + quantity)
    Map.put(hours_per_year, name, years_updated)
  end

  defp sum_hours_per_month(name, quantity, month, hours_per_month) do
    months = hours_per_month[name]
    months_updated = Map.put(months, month, months[month] + quantity)
    Map.put(hours_per_month, name, months_updated)
  end

  defp sum_hours_all_hours(name, quantity, all_hours) do
    Map.put(all_hours, name, all_hours[name] + quantity)
  end

  defp report_acc do
    all_hours = initial_state_all_hours()
    hours_per_month = initial_state_hours_per_month()
    hours_per_year = initial_state_hours_per_year()

    %{
      "all_hours" => all_hours,
      "hours_per_month" => hours_per_month,
      "hours_per_year" => hours_per_year
    }
  end

  defp initial_state_hours_per_month() do
    months_map = Enum.into(@months, %{}, &{&1, 0})
    Enum.into(@names, %{}, &{&1, months_map})
  end

  defp initial_state_all_hours() do
    Enum.into(@names, %{}, &{&1, 0})
  end

  defp initial_state_hours_per_year() do
    years_map = Enum.into(@years, %{}, &{&1, 0})
    Enum.into(@names, %{}, &{&1, years_map})
  end
end
