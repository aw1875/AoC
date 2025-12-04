package main

import (
	"AoC/day01"
	"AoC/day02"
	"AoC/day03"
	"fmt"
	"time"
)

func main() {
	start := time.Now()
	fmt.Println("==== AoC 2025 - Day 01 ====")
	day01 := day01.Run("day01/inputs/input.txt")
	fmt.Println("Part 1:", day01.ResetCount)
	fmt.Println("Part 2:", day01.Rotations)
	fmt.Printf("Time taken: %s\n", time.Since(start))
	fmt.Printf("===========================\n\n")

	start = time.Now()
	fmt.Println("==== AoC 2025 - Day 02 ====")
	part, part2 := day02.Run("day02/inputs/input.txt")
	fmt.Println("Part 1:", part)
	fmt.Println("Part 2:", part2)
	fmt.Printf("Time taken: %s\n", time.Since(start))
	fmt.Printf("===========================\n\n")

	start = time.Now()
	fmt.Println("==== AoC 2025 - Day 03 ====")
	part1, part2 := day03.Run("day03/inputs/input.txt")
	fmt.Println("Part 1:", part1)
	fmt.Println("Part 2:", part2)
	fmt.Printf("Time taken: %s\n", time.Since(start))
	fmt.Printf("===========================\n\n")
}
