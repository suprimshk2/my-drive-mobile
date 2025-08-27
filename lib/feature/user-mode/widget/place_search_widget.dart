import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mydrivenepal/feature/user-mode/data/places_service.dart';

class PlaceSearchWidget extends StatefulWidget {
  final String hintText;
  final IconData prefixIcon;
  final Color prefixIconColor;
  final Function(PlaceDetails) onPlaceSelected;
  final LatLng? currentLocation;
  final bool isLoading;
  final String? initialValue;
  final Widget? suffixIcon;

  const PlaceSearchWidget({
    Key? key,
    required this.hintText,
    required this.prefixIcon,
    required this.prefixIconColor,
    required this.onPlaceSelected,
    this.currentLocation,
    this.isLoading = false,
    this.initialValue,
    this.suffixIcon,
  }) : super(key: key);

  @override
  _PlaceSearchWidgetState createState() => _PlaceSearchWidgetState();
}

class _PlaceSearchWidgetState extends State<PlaceSearchWidget> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _debounceTimer;
  List<PlacePrediction> _predictions = [];
  bool _isSearching = false;
  bool _showPredictions = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    if (widget.initialValue != null) {
      _controller.text = widget.initialValue!;
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _showPredictions = _focusNode.hasFocus && _predictions.isNotEmpty;
    });
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _errorMessage = null;

    if (query.trim().isEmpty) {
      setState(() {
        _predictions.clear();
        _showPredictions = false;
        _isSearching = false;
      });
      return;
    }

    if (query.length < 2) {
      setState(() {
        _predictions.clear();
        _showPredictions = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    _debounceTimer = Timer(const Duration(milliseconds: 600), () {
      _fetchPredictions(query);
    });
  }

  Future<void> _fetchPredictions(String query) async {
    try {
      final predictions = await PlacesService.getPlacePredictions(
        query,
        location: widget.currentLocation,
        radius: 50000, // 50km radius
      );

      if (mounted) {
        setState(() {
          _predictions = predictions;
          _showPredictions = _focusNode.hasFocus && predictions.isNotEmpty;
          _isSearching = false;
          _errorMessage = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSearching = false;
          _errorMessage = 'Failed to search places. Please try again.';
        });
      }
    }
  }

  Future<void> _onPredictionSelected(PlacePrediction prediction) async {
    setState(() {
      _isSearching = true;
      _showPredictions = false;
      _errorMessage = null;
    });

    try {
      final placeDetails =
          await PlacesService.getPlaceDetails(prediction.placeId);

      if (placeDetails != null) {
        _controller.text = placeDetails.formattedAddress;
        widget.onPlaceSelected(placeDetails);
        _focusNode.unfocus();
      } else {
        setState(() {
          _errorMessage = 'Could not get place details. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to get place details. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSearching = false;
        });
      }
    }
  }

  void _clearSearch() {
    _controller.clear();
    setState(() {
      _predictions.clear();
      _showPredictions = false;
      _errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search TextField
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  _errorMessage != null ? Colors.red[300]! : Colors.grey[300]!,
              width: _errorMessage != null ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
              prefixIcon:
                  Icon(widget.prefixIcon, color: widget.prefixIconColor),
              suffixIcon: _buildSuffixIcon(),
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),

        // Error message
        if (_errorMessage != null)
          Padding(
            padding: EdgeInsets.only(top: 8, left: 4),
            child: Text(
              _errorMessage!,
              style: TextStyle(
                color: Colors.red[600],
                fontSize: 12,
              ),
            ),
          ),

        // Predictions List
        if (_showPredictions && _predictions.isNotEmpty)
          Container(
            margin: EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            constraints: BoxConstraints(maxHeight: 250),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _predictions.length,
              itemBuilder: (context, index) {
                final prediction = _predictions[index];
                return _buildPredictionTile(prediction);
              },
            ),
          ),

        // No results message
        if (_showPredictions &&
            _predictions.isEmpty &&
            !_isSearching &&
            _controller.text.length >= 2)
          Container(
            margin: EdgeInsets.only(top: 8),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.search_off, color: Colors.grey[500], size: 20),
                SizedBox(width: 12),
                Text(
                  'No places found for "${_controller.text}"',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildSuffixIcon() {
    if (_isSearching) {
      return Padding(
        padding: EdgeInsets.all(12),
        child: SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).primaryColor,
            ),
          ),
        ),
      );
    } else if (_controller.text.isNotEmpty) {
      return IconButton(
        icon: Icon(Icons.clear, color: Colors.grey[500], size: 20),
        onPressed: _clearSearch,
        padding: EdgeInsets.all(8),
        constraints: BoxConstraints(minWidth: 32, minHeight: 32),
      );
    } else {
      return widget.suffixIcon ?? SizedBox.shrink();
    }
  }

  Widget _buildPredictionTile(PlacePrediction prediction) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.location_on,
          color: Colors.blue[600],
          size: 18,
        ),
      ),
      title: Text(
        prediction.mainText,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        prediction.secondaryText,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 12,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () => _onPredictionSelected(prediction),
    );
  }
}
