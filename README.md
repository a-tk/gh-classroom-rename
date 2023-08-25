# gh-classroom-rename
A short script that searches for a string in a repositories README file, then adds that string to the parent directory. 

## Purpose

This script is designed to make working with github classroom easier from an 
instructors perspective. 

The problem being solved here is that cloning a Classroom results in 
30-40 (or more!) repositories that have the format: 

    <assignment-name>-<github-username>

This may seem like enough information at first glance, but consider that students have the 
ability to use their personal github accounts to work on the assignments.

Therefore, the problem of dereferencing a username like 'supercool-007' to a students name 
that is actually enrolled in the class is created for the instructor. 

Sure, we could just ask them to provide their github usernames, and create a map from that,
but doing it automatically is more fun. 

## How it works

This script works in three modes: 

 1. Collect mode
 2. Apply mode
 3. Basic mode

### General parameters

    ghc-rename -m <basic|collect|apply> -f <location of the mapfile to create or to use> -r <parent directory containing student repositories>

### Directory Structure

The assumed directory structure is

    classroom/
        <course-name and section>/
            <assignment submissions>/
                ...
                <student repository>
                    README.md
                <student repository>
                ...

### Collect mode

The purpose of this mode is to collect information and create a map file. 

The two pieces of information required are:

 1. The students github username is collected from the downloaded repository. 
 2. The students name is collected from a submitted assignment

With this information, a map file is created

### Apply mode

The purpose of this mode is to apply a .map file to a collection of folders, appending the mapped string 
to each matched folder.

For example, if the .map file contains

    supercool-007 andre-keys

And the assignment repository is:

    p0-supercool-007

The script will rename the repository directorty (it does not rename the git repository!)

    p0-supercool-007-andre-keys

### Prerequisites

 - A collection of unix tools are available (grep, awk, etc).
 - Create a folder structure (as defined below) to house student assignments locally.
 - Download student repos (the [gh](https://cli.github.com/) program works well for this).
 - To create a map, it is assumed that at least 1 assignment has been completed by the students.
   - The assignment should at least have a README.md file containing some information. 
