def analyze_numbers(numbers, target_number):
    total_sum = 0
    max_number = float('-inf')
    target_count = 0

    for num in numbers:
        # Task 1: Calculate the sum of all numbers
        total_sum += num
        
        # Task 2: Find the maximum number in the list
        if num > max_number:
            max_number = num
        
        # Task 3: Count occurrences of the target number in the list
        if num == target_number:
            target_count += 1

    return total_sum, max_number, target_count

# Example usage:
numbers_list = [10, 5, 7, 3, 10, 8, 10]
target = 10
sum_result, max_result, target_count_result = analyze_numbers(numbers_list, target)

print("List of numbers:", numbers_list)
print("Sum of numbers:", sum_result)
print("Maximum number:", max_result)
print(f"Occurrences of {target}: {target_count_result}")
