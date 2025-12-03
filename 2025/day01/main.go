package day01

import (
	"bufio"
	"log"
	"math"
	"os"
	"strconv"
)

type Dial struct {
	Value      int
	ResetCount int
	Rotations  int
}

func (d *Dial) rotate(instruction string) {
	dir := 1
	if instruction[0] == 'L' {
		dir = -1
	}

	steps, _ := strconv.Atoi(instruction[1:])

	prev := d.Value
	d.Value += dir * steps

	if d.Value%100 == 0 {
		d.ResetCount++
	}

	prevRing := prev / 100
	currRing := d.Value / 100
	d.Rotations += int(math.Abs(float64(currRing - prevRing)))
}

func Run(filePath string) *Dial {
	file, err := os.Open(filePath)
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	dial := &Dial{Value: 50}

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		line := scanner.Text()
		if len(line) < 2 {
			continue
		}

		dial.rotate(line)
	}

	if err := scanner.Err(); err != nil {
		log.Fatal(err)
	}

	return dial
}
