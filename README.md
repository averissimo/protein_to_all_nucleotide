# Reverse translate protein to nucleotide

Considering all possible sequences.

The algorithm is pretty simple, it generates a directed graph with all possible variations at each codon and writes the possible sequences to disk with minimal memory usage.

In practice, it is an array of possible codons for each protein and does a depth-first search of the graph, generating a string at each leaf with all parents. It is a recursive algorithm to keep memory usage minimum.

## Usage

    $ ruby revtranslate_it.rb [codon table number] [max sequences per contig]

- input.query: this file needs to exist with fasta sequences;
- [codon table number]: sets codon table conversion id, if not specified defaults to '1';
- [max sequences per contig]: sets number of sequences generated per fasta sequence in input.query;
  - note that if you want to set this option, you require to set codon table number


## Example

Using codon table 1, the sequence 'AMG' should be translated to 16 nucleotide sequences:

    "gctatgggt", "gctatgggc", "gctatggga", "gctatgggg",
     "gccatgggt", "gccatgggc", "gccatggga", "gccatgggg",
     "gcaatgggt", "gcaatgggc", "gcaatggga", "gcaatgggg",
     "gcgatgggt", "gcgatgggc", "gcgatggga", "gcgatgggg"

## Requirements

- Ruby Programing Environment
- [Bioruby](http://bioruby.org/) gem (`$ gem install bio`)

## Ackowledgements

This tool was created as a part of [FCT](www.fct.pt) grant SFRH/BD/97415/2013

Developer:  [André Veríssimo](http://web.tecnico.ulisboa.pt/andre.verissimo/)
