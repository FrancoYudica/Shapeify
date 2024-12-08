import json
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation, PillowWriter
import os


def plot_fitness(image_generations, folder):
    fitnesses = [
        generation["generated_individual"]["fitness"]
        for generation in image_generations
    ]

    plt.figure(figsize=(10, 6))
    plt.plot(range(1, len(fitnesses) + 1), fitnesses, marker='o', linestyle='-', color='b')

    # Customize the plot
    plt.title("Fitness of generated individuals during image generation process")
    plt.xlabel("Generated individual")
    plt.ylabel("Fitness")
    plt.grid()
    
    # Save the plot to an image
    output_file = os.path.join(folder, 'fitness.png')
    plt.savefig(output_file, dpi=300, bbox_inches='tight')  # High-quality image

def plot_time_taken(image_generations, folder):
    time_taken = [
        generation["time_taken"]
        for generation in image_generations
    ]

    plt.figure(figsize=(10, 6))
    plt.plot(range(1, len(time_taken) + 1), time_taken, marker='o', linestyle='-', color='b')

    # Customize the plot
    plt.title("Time taken for each generated individual during image generation process")
    plt.xlabel("Generated individual")
    plt.ylabel("Time taken (seconds)")
    plt.grid()
    
    # Save the plot to an image
    output_file = os.path.join(folder, 'time_taken.png')
    plt.savefig(output_file, dpi=300, bbox_inches='tight')  # High-quality image


def plot_metric(image_generations, folder):
    metric_scores = [
        generation["generated_individual"]["metric_score"]
        for generation in image_generations
    ]

    plt.figure(figsize=(10, 6))
    plt.plot(range(1, len(metric_scores) + 1), metric_scores, marker='o', linestyle='-', color='b')

    # Customize the plot
    plt.title("Delta E 94 of generated individuals during image generation process")
    plt.xlabel("Generated individual")
    plt.ylabel("Delta E 94")
    plt.grid()
    
    # Save the plot to an image
    output_file = os.path.join(folder, 'metric.png')
    plt.savefig(output_file, dpi=300, bbox_inches='tight')  # High-quality image


def plot_area(image_generations, folder, log_scale=False, outlier_threshold=None):
    # Calculate areas
    areas = [
        generation["generated_individual"]["size_x"] * generation["generated_individual"]["size_y"]
        for generation in image_generations
    ]
    
    # Handle outliers if threshold is provided
    if outlier_threshold is not None:
        filtered_indices = [i for i, area in enumerate(areas) if area <= outlier_threshold]
        areas = [areas[i] for i in filtered_indices]
        x_values = [i + 1 for i in filtered_indices]  # Ensure x-values stay consistent
    else:
        x_values = list(range(1, len(areas) + 1))
    
    plt.figure(figsize=(10, 6))
    plt.plot(x_values, areas, marker="o", linestyle="-", color="b")
    
    # Logarithmic scale for y-axis
    if log_scale:
        plt.yscale("log")
        plt.ylabel("Log of Area")
    else:
        plt.ylabel("Area")
    
    # Customize the plot
    plt.title("Area of Generated Individuals")
    plt.xlabel("Generated Individual")
    plt.grid(axis="y", linestyle="--", alpha=0.7)
    
    # Save the plot
    output_file = os.path.join(folder, "area.png")
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
        plot_fitness,
        plot_time_taken,
        plot_metric,
        lambda individual_generations, folder: plot_area(individual_generations, folder, True, None)
    ]

    for image_generation in image_generations:

        individual_generations = image_generation["individual_generations"]

        for plot_function in plot_functions:
            plot_function(individual_generations, "out")
