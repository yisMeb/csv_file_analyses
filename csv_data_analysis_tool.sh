#!/bin/bash

echo "Enter the name of the CSV file: "
read csv_file_name

if [ ! -f "$csv_file_name" ]; then
  echo "File $csv_file_name does not exist."
  exit 1
fi

file_extension="${csv_file_name##*.}"
if [[ "$file_extension" != "csv" ]]; then
  echo "The file is not of type CSV."
  exit 1
fi

function display_rows_and_columns() {
    num_columns=$(head -n 1 "$csv_file_name" | tr ',' '\n' | wc -l)

    num_rows=$(tail -n +2 "$csv_file_name" | wc -l)

    echo "Number of columns: $num_columns"
    echo "Number of rows: $num_rows"
}

function list_unique_values() {
  echo "Enter column number: "
  read column_number
 unique=$(cut -d ',' -f $column_num "$csv_file_name" | sort | uniq)
  echo "The unique values in the column are: $unique"

}

function display_column_names() {
  echo "The column names are:"
  for column_name in "${columns[@]}"; do
    echo "  $column_name"
  done
}

function minimum_maximum_values() {
  echo "The minimum and maximum values for numeric columns are:"
  for column_name in "${numeric_columns[@]}"; do
    echo "  $column_name: ${min_values[$column_name]} - ${max_values[$column_name]}"
  done
}

function most_frequent_value() {
  echo "The most frequent value for categorical columns are:"
  for column_name in "${categorical_columns[@]}"; do
    echo "  $column_name: ${most_frequent_values[$column_name]}"
  done
}

function summary_statistics() {
  echo "The summary statistics for numeric columns are:"
  for column_name in "${numeric_columns[@]}"; do
    echo "  $column_name: mean = ${mean_values[$column_name]}, median = ${median_values[$column_name]}, standard deviation = ${standard_deviation_values[$column_name]}"
  done
}

function filtering_and_extracting() {
  echo "Enter the filtering condition: "
  read condition
}

function sorting() {
  echo "Enter the name of the column to sort: "
  read column_name
}

#menu
menu_options=(
  "1.Display the number of rows and columns in the CSV file"
  "2.List unique values in a specified column"
  "3.Display column names (header)"
  "4.Minimum and maximum values for numeric columns"
  "5.The most frequent value for categorical columns"
  "6.Calculating summary statistics (mean, median, standard deviation) for numeric columns"
  "7.Filtering and extracting rows and column based on user-defined conditions"
  "8.Sorting the CSV file based on a specific column"
  "0.Exit"
)
echo "Welcome to the CSV file analysis tool!"
echo "Please select one of the following options:"
for option in "${menu_options[@]}"; do
  echo "  ${option}"
done

echo "Enter your choice: "
read choice

while [[ $choice != 0 ]]; do
  case $choice in
    "1")
      display_rows_and_columns
      ;;
    "2")
      list_unique_values
      ;;
    "3")
      display_column_names
      ;;
    "4")
      minimum_maximum_values
      ;;
    "5")
      most_frequent_value
      ;;
    "6")
      summary_statistics
      ;;
    "7")
      filtering_and_extracting
      ;;
    "8")
      sorting
      ;;
  esac
  echo "Please select one of the following options:"
  for option in "${menu_options[@]}"; do
    echo "  ${option}"
  done
  echo "Enter your choice: "
  read choice
done

echo "Thank you for using the CSV file analysis tool!"
