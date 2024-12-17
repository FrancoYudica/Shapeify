import json
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation, PillowWriter
import os


def plot_metric_multiple_algorithms(individual_generations_list, algorithm_names, folder):
    plt.figure(figsize=(10, 6))
    
    # Loop through each algorithm's generations and plot
    for individual_generations, algorithm_name in zip(individual_generations_list, algorithm_names):
        metric_scores = [
            generation["generated_individual"]["metric_score"]
            for generation in individual_generations
        ]
        
        # Plot the curve with a label for the algorithm
        plt.plot(
            range(1, len(metric_scores) + 1),
            metric_scores,
            marker='o',
            linestyle='-',
            label=algorithm_name
        )
    
    # Customize the plot
    plt.title("Delta E 94 Comparison Between Algorithms")
    plt.xlabel("Image generation stage")
    plt.ylabel("Delta E 94")
    plt.legend(title="Algorithms")  # Add legend to differentiate algorithms
    plt.grid()
    
    # Save the plot to an image
    output_file = os.path.join(folder, 'metric_algorithms_comparison.png')
    plt.savefig(output_file, dpi=300, bbox_inches='tight')  # High-quality image




def plot_area_multiple_algorithms(individual_generations_list, algorithm_names, folder):
    plt.figure(figsize=(10, 6))
    
    # Loop through each algorithm's generations and plot
    for individual_generations, algorithm_name in zip(individual_generations_list, algorithm_names):
        areas = [
            generation["generated_individual"]["size_x"] * generation["generated_individual"]["size_y"]
            for generation in individual_generations
        ]
        
        # Plot the curve with a label for the algorithm
        plt.plot(
            range(1, len(areas) + 1),
            areas,
            marker='o',
            linestyle='-',
            label=algorithm_name
        )
    
    # Customize the plot
    plt.title("Area comparison between Algorithms")
    plt.xlabel("Image generation stage")
    plt.yscale("log")
    plt.ylabel("Log of Area")
    plt.legend(title="Algorithms")  # Add legend to differentiate algorithms
    plt.grid()
    
    # Save the plot to an image
    output_file = os.path.join(folder, 'area_algorithms_comparison.png')
    plt.savefig(output_file, dpi=300, bbox_inches='tight')  # High-quality image

def get_individual_generations(profile_file_path):
    # Load the data from a file
    with open(profile_file_path, 'r') as file:
        data = json.load(file)

    # Extract the metric values
    individual_generations = data["image_generations"][0]["individual_generations"]
    return individual_generations

if __name__ == "__main__":

    paths = [
        "results/monal_lisa_image_generation/random/execution_time_limit/profile.json",
        "results/monal_lisa_image_generation/best_of_random/execution_time_limit/profile.json",
        "results/monal_lisa_image_generation/genetic/execution_time_limit/profile.json"
    ]

    individual_generations_list = [get_individual_generations(path) for path in paths]
    algorithm_names = ["Random", "Best of random", "Genetic"]

    functions = [
        plot_metric_multiple_algorithms,
        plot_area_multiple_algorithms
    ]
    for f in functions:
        f(individual_generations_list, algorithm_names, "out")