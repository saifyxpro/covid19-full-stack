import {
    FETCH_CORONA_STATISTICS,
    SHOW_COUNTRY_STATISTICS,
    FETCH_MARKERS,
    MAP_STYLE,
    SET_ACTION,
    BASE_URL,
    ENDPOINTS,
} from './constants';

// Action creators
export const dispatchStatistics = data => ({
    type: FETCH_CORONA_STATISTICS,
    payload: data
});

export const dispatchMarkers = data => ({
    type: FETCH_MARKERS,
    payload: data
});

export const showCountryStatistics = item => ({
    type: SHOW_COUNTRY_STATISTICS,
    payload: {item}
});

export const setMapStyle = style => ({
    type: MAP_STYLE,
    payload: {style}
});

export const setAction = action => ({
    type: SET_ACTION,
    payload: {action}
});

// Enhanced async actions with error handling
export const fetchCoronaStatistics = () => async dispatch => {
    try {
        const response = await fetch(`${BASE_URL}${ENDPOINTS.STATISTICS}`, {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json',
            },
        });

        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }

        const data = await response.json();
        dispatch(dispatchStatistics(data));
        return data;
    } catch (error) {
        console.error('Error fetching corona statistics:', error);
        // You could dispatch an error action here
        // dispatch({ type: 'FETCH_STATISTICS_ERROR', payload: error.message });
        throw error;
    }
};

export const fetchMarkers = () => async dispatch => {
    try {
        const response = await fetch(`${BASE_URL}${ENDPOINTS.MARKERS}`, {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json',
            },
        });

        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }

        const data = await response.json();
        dispatch(dispatchMarkers(data));
        return data;
    } catch (error) {
        console.error('Error fetching markers:', error);
        // You could dispatch an error action here
        // dispatch({ type: 'FETCH_MARKERS_ERROR', payload: error.message });
        throw error;
    }
};

// Utility function to check API health
export const checkAPIHealth = async () => {
    try {
        const response = await fetch(`${BASE_URL.replace('/api', '')}/health`);
        return response.ok;
    } catch (error) {
        console.error('API health check failed:', error);
        return false;
    }
};