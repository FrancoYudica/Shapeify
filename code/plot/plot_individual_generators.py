import json
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation, PillowWriter
import os



def plot_generations_metric_boxplot(individual_generations, folder):
    # Extract metric values
    metric_values = [
        individual_generation["generated_individual"]["metric_score"]
        for individual_generation in individual_generations
    ]

    # Calculate statistics
    mean_val = sum(metric_values) / len(metric_values)
    median_val = sorted(metric_values)[len(metric_values) // 2]
    min_val = min(metric_values)
    max_val = max(metric_values)

    # Plot a boxplot
    plt.figure(figsize=(10, 6))
    box = plt.boxplot(metric_values, showmeans=True, notch=True, patch_artist=True)

    # Add statistical annotations
    plt.text(1.1, mean_val, f"Mean = {mean_val:.2f}", color="blue", fontsize=10)
    plt.text(1.1, median_val, f"Median = {median_val:.2f}", color="green", fontsize=10)
    plt.text(1.1, max_val, f"Max = {max_val:.2f}", color="red", fontsize=10)
    plt.text(1.1, min_val, f"Min = {min_val:.2f}", color="purple", fontsize=10)

    # Customize boxplot appearance
    colors = ["#FFC107"]  # Yellow color for the box
    for patch, color in zip(box['boxes'], colors):
        patch.set_facecolor(color)

    # Add plot title and labels
    plt.title("Delta E 94 Distribution")
    plt.ylabel("Metric")
    plt.xticks([1], ["Execution"])  # Single label for a single box
    plt.grid(axis='y', linestyle='--', alpha=0.7)

    # Save the plot to an image
    output_file = os.path.join(folder, 'metric_boxplot.png')
    plt.savefig(output_file, dpi=300, bbox_inches='tight')
    plt.close()



def plot_generations_time_taken_boxplot(individual_generations, folder):
    # Extract metric values
    time_taken_values = [
        individual_generation["time_taken"]
        for individual_generation in individual_generations
    ]

    # Calculate statistics
    mean_val = sum(time_taken_values) / len(time_taken_values)
    median_val = sorted(time_taken_values)[len(time_taken_values) // 2]
    min_val = min(time_taken_values)
    max_val = max(time_taken_values)

    # Plot a boxplot
    plt.figure(figsize=(10, 6))
    box = plt.boxplot(time_taken_values, showmeans=True, notch=True, patch_artist=True)

    # Add statistical annotations
    plt.text(1.1, mean_val, f"Mean = {mean_val:.2f}", color="blue", fontsize=10)
    plt.text(1.1, median_val, f"Median = {median_val:.2f}", color="green", fontsize=10)
    plt.text(1.1, max_val, f"Max = {max_val:.2f}", color="red", fontsize=10)
    plt.text(1.1, min_val, f"Min = {min_val:.2f}", color="purple", fontsize=10)

    # Customize boxplot appearance
    colors = ["#FFC107"]  # Yellow color for the box
    for patch, color in zip(box['boxes'], colors):
        patch.set_facecolor(color)

    # Add plot title and labels
    plt.title("Time taken distribution")
    plt.ylabel("Time taken (seconds)")
    plt.xticks([1], ["Execution"])  # Single label for a single box
    plt.grid(axis='y', linestyle='--', alpha=0.7)

    # Save the plot to an image
    output_file = os.path.join(folder, 'time_taken_boxplot.png')
    plt.savefig(output_file, dpi=300, bbox_inches='tight')
    plt.close()


def plot_positions(individual_generations, folder):
    # Extract positions, metric scores, and canvas dimensions
    positions = [
        (
            individual_generation["generated_individual"]["position_x"],
            individual_generation["generated_individual"]["position_y"]
        )
        for individual_generation in individual_generations
    ]
    metric_scores = [
        individual_generation["generated_individual"]["metric_score"]
        for individual_generation in individual_generations
    ]
    width = individual_generations[0]["params"]["target_texture_width"]
    height = individual_generations[0]["params"]["target_texture_height"]

    # Separate x and y coordinates
    x_positions, y_positions = zip(*positions)

    # Create a scatter plot
    plt.figure(figsize=(10, 10))
    plt.scatter(x_positions, y_positions, s=50, c="blue", alpha=0.6, edgecolor="k")
    
    # Add metric scores as annotations
    for (x, y, score) in zip(x_positions, y_positions, metric_scores):
        plt.text(
            x, y, f"{score:.2f}",
            fontsize=9, ha="left", va="bottom",
            color="black", alpha=0.8
        )

    # Set canvas limits
    plt.xlim(0, width)
    plt.ylim(0, height)

    # Add titles and labels
    plt.title("Individuals' Positions with Metric Scores")
    plt.xlabel("X Position")
    plt.ylabel("Y Position")

    # Add grid for better visualization
    plt.grid(color="gray", linestyle="--", linewidth=0.5, alpha=0.7)

    # Save the plot to an image
    output_file = os.path.join(folder, "individual_positions_with_scores.png")
    plt.savefig(output_file, dpi=300, bbox_inches="tight")
    plt.close()

    print(f"Plot saved at: {output_file}")



if __name__ == "__main__":

    # Load the data from a file
    file_path = 'profile.json'  # Replace with your file path
    with open(file_path, 'r') as file:
        data = json.load(file)

    # Extract the metric values
    image_generations = data["image_generations"]

    plot_functions = [
        plot_generations_metric_boxplot,
        plot_generations_time_taken_boxplot,
        plot_positions
    ]



    for image_generation in image_generations:

        individual_generations = image_generation["individual_generations"]

        for plot_function in plot_functions:
            plot_function(individual_generations, "out")
