import json
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation, PillowWriter
import os


def plot_generations_average_fitness(generations, folder):
    # Calculate average fitness for each generation
    average_fitness = [
        sum(individual["fitness"] for individual in generation) / len(generation)
        for generation in generations
    ]

    # Plot the average fitness against generation number
    plt.figure(figsize=(10, 6))
    plt.plot(range(1, len(average_fitness) + 1), average_fitness, marker='o', linestyle='-', color='b')

    # Customize the plot
    plt.title("Average Fitness Over Generations")
    plt.xlabel("Generation Number")
    plt.ylabel("Average Fitness")
    plt.grid()
    
    # Save the plot to an image
    output_file = os.path.join(folder, 'average_fitness_plot.png')  # Replace with your desired file name and format
    plt.savefig(output_file, dpi=300, bbox_inches='tight')  # High-quality image


def plot_generations_fitness_boxplot(generations, folder):
    # Extract fitness values for each generation
    fitness_values = [
        [individual["fitness"] for individual in generation]
        for generation in generations
    ]

    # Plot a boxplot for the fitness values
    plt.figure(figsize=(10, 6))
    plt.boxplot(fitness_values, showmeans=True, notch=True)

    # Customize the plot
    plt.title("Fitness Distribution Over Generations")
    plt.xlabel("Generation Number")
    plt.ylabel("Fitness")
    plt.xticks(range(1, len(fitness_values) + 1), labels=[f"{i+1}" for i in range(len(fitness_values))])
    plt.grid(axis='y', linestyle='--', alpha=0.7)

    # Save the plot to an image
    output_file = os.path.join(folder, 'fitness_boxplot.png')  # Replace with your desired file name and format
    plt.savefig(output_file, dpi=300, bbox_inches='tight')  # High-quality image


def plot_generations_max_fitness(generations, folder):
    # Calculate max fitness for each generation
    max_fitness = [
        max(individual["fitness"] for individual in generation)
        for generation in generations
    ]

    # Plot the max fitness against generation number
    plt.figure(figsize=(10, 6))
    plt.plot(range(1, len(max_fitness) + 1), max_fitness, marker='o', linestyle='-', color='b')

    # Customize the plot
    plt.title("Max Fitness Over Generations")
    plt.xlabel("Generation Number")
    plt.ylabel("Max Fitness")
    plt.grid()
    
    # Save the plot to an image
    output_file = os.path.join(folder, 'max_fitness_plot.png')
    plt.savefig(output_file, dpi=300, bbox_inches='tight')  # High-quality image




def plot_generations_average_score(generations, folder):
    # Calculate average metric_score for each generation
    metric_scores = [
        sum(individual["metric_score"] for individual in generation) / len(generation)
        for generation in generations
    ]

    # Plot the average fitness against generation number
    plt.figure(figsize=(10, 6))
    plt.plot(range(1, len(metric_scores) + 1), metric_scores, marker='o', linestyle='-', color='b')

    # Customize the plot
    plt.title("Average Delta E 94 Over Generations")
    plt.xlabel("Generation Number")
    plt.ylabel("Average Delta E 94")
    plt.grid()
    
    # Save the plot to an image
    output_file = os.path.join(folder, 'average_metric_score_plot.png')
    plt.savefig(output_file, dpi=300, bbox_inches='tight')  # High-quality image

def plot_generations_score_boxplot(generations, folder):
    metric_scores = [
        [individual["metric_score"] for individual in generation]
        for generation in generations
    ]

    # Plot a boxplot for the fitness values
    plt.figure(figsize=(10, 6))
    plt.boxplot(metric_scores, showmeans=True, notch=True)

    # Customize the plot
    plt.title("Delta E 94 Distribution Over Generations")
    plt.xlabel("Generation Number")
    plt.ylabel("Delta E 94")
    plt.xticks(range(1, len(metric_scores) + 1), labels=[f"{i+1}" for i in range(len(metric_scores))])
    plt.grid(axis='y', linestyle='--', alpha=0.7)

    # Save the plot to an image
    output_file = os.path.join(folder, 'metric_score_boxplot.png')
    plt.savefig(output_file, dpi=300, bbox_inches='tight')

def plot_generations_min_score(generations, folder):
    max_metric_score = [
        min(individual["metric_score"] for individual in generation)
        for generation in generations
    ]

    # Plot the max fitness against generation number
    plt.figure(figsize=(10, 6))
    plt.plot(range(1, len(max_metric_score) + 1), max_metric_score, marker='o', linestyle='-', color='b')

    # Customize the plot
    plt.title("Min Delta E 94 Over Generations")
    plt.xlabel("Generation Number")
    plt.ylabel("Min Delta E 94")
    plt.grid()
    
    # Save the plot to an image
    output_file = os.path.join(folder, 'min_metric_score_plot.png')
    plt.savefig(output_file, dpi=300, bbox_inches='tight')

def plot_positions(generations, save_path=None):
    # Extract positions from the dataset
    positions_per_generation = [
        [(individual["position_x"], individual["position_y"]) for individual in generation]
        for generation in generations
    ]

    # Prepare data for animation
    x_data = [[p[0] for p in positions] for positions in positions_per_generation]
    y_data = [[p[1] for p in positions] for positions in positions_per_generation]

    # Initialize the plot
    fig, ax = plt.subplots(figsize=(8, 8))
    scatter = ax.scatter([], [], s=50, c='blue')
    ax.set_xlim(0, max(max(x) for x in x_data) * 1.1)
    ax.set_ylim(0, max(max(y) for y in y_data) * 1.1)
    ax.set_title("2D Positions of Individuals Over Generations")
    ax.set_xlabel("X Position")
    ax.set_ylabel("Y Position")

    # Update function for animation
    def update(frame):
        scatter.set_offsets(list(zip(x_data[frame], y_data[frame])))
        ax.set_title(f"2D Positions of Individuals - Generation {frame + 1}")

    # Create animation
    ani = FuncAnimation(fig, update, frames=len(x_data), repeat=False)

    # Save animation if save_path is provided
    if save_path:
        if save_path.endswith('.gif'):
            writer = PillowWriter(fps=2)  # Adjust fps as needed
            ani.save(save_path, writer=writer)
        elif save_path.endswith('.mp4'):
            ani.save(save_path, writer='ffmpeg', fps=30)  # Ensure ffmpeg is installed
        else:
            raise ValueError("Unsupported file format. Use '.gif' or '.mp4'.")

    # Show the animation
    plt.show()

    # Return the animation object to keep it in memory
    return ani

if __name__ == "__main__":

    # Load the data from a file
    file_path = 'profile.json'  # Replace with your file path
    with open(file_path, 'r') as file:
        data = json.load(file)

    # Extract the fitness values
    image_generations = data["image_generations"]

    plot_functions = [
        plot_generations_average_fitness,
        plot_generations_max_fitness,
        plot_generations_fitness_boxplot,
        plot_generations_average_score,
        plot_generations_min_score,
        plot_generations_score_boxplot
    ]



    for image_generation in image_generations:

        individual_generations = image_generation["individual_generations"]

        for individual_generation in individual_generations:
            if len(individual_generation["genetic_generations"]) > 0:

                for plot_function in plot_functions:
                    plot_function(individual_generation["genetic_generations"], "out")

                
                plot_positions(individual_generation["genetic_generations"], "out/positions.gif")
                