import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';

class TableScreen extends StatefulWidget {
  const TableScreen({super.key});

  @override
  State<TableScreen> createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {
  late final Stream<List<Movie>> _movies;
  int _sortColumn = 0;
  bool _ascending = false;

  @override
  void initState() {
    super.initState();
    _movies = const MovieService().watchMovies();
  }

  void _sort(int column, bool ascending) {
    setState(() {
      _sortColumn = column;
      _ascending = ascending;
    });
  }

  int _compare(Movie a, Movie b) {
    final result = switch (_sortColumn) {
      0 => a.rating.compareTo(b.rating),
      1 => a.releaseYear.compareTo(b.releaseYear),
      _ => a.runningTime.compareTo(b.runningTime),
    };
    return _ascending ? result : -result;
  }

  Widget _buildTable(List<Movie> movies) {
    final sorted = [...movies]..sort((a, b) => b.rating.compareTo(a.rating));
    final rows = sorted.take(10).toList()..sort(_compare);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        sortColumnIndex: _sortColumn,
        sortAscending: _ascending,
        columns: [
          DataColumn(
            label: const Text('Ocjena'),
            numeric: true,
            onSort: _sort,
          ),
          DataColumn(
            label: const Text('Godina'),
            numeric: true,
            onSort: _sort,
          ),
          DataColumn(
            label: const Text('Trajanje (min)'),
            numeric: true,
            onSort: _sort,
          ),
          const DataColumn(label: Text('Naslov')),
        ],
        rows: [
          for (final movie in rows)
            DataRow(
              cells: [
                DataCell(Text(movie.rating.toStringAsFixed(1))),
                DataCell(Text(movie.releaseYear.toString())),
                DataCell(Text(movie.runningTime.toString())),
                DataCell(Text(movie.title)),
              ],
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('10 najbolje ocijenjenih - uživo')),
      body: StreamBuilder<List<Movie>>(
        stream: _movies,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Greška pri dohvaćanju filmova'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return _buildTable(snapshot.data!);
        },
      ),
    );
  }
}
