#!/Users/bernd/.pyenv/versions/Scripts/bin/python
# Lidarr API implementation
#
# A simple barebone Lidarr API implementation for Python.
# Not all endpoints are implemented yet
__author__ = 'Nachtalb'
__version__ = '1.0.0'
__date__ = '2019-07-31'

import requests

from typing import Dict


class LidarrAPI:
    version_root = 'api/v1'

    def __init__(self, url, api_token):
        self.base_url = url.rstrip('/')
        self.api_token = api_token

    def _request(self, *, endpoint: str, params: Dict = None, data: Dict = None, method: str = None) -> Dict:
        data = data or {}
        params = params or {}

        method = (method or 'get').lower()
        if method not in ['get', 'post', 'delete', 'patch', 'put']:
            raise AttributeError(f'{method} is not an availalbe request method')

        real_method = getattr(requests, method)

        built_url = f'{self.base_url}/{self.version_root}/{endpoint}'

        params.update({'apikey': self.api_token})

        response = real_method(url=built_url, data=data, params=params)
        response.raise_for_status()

        return response.json()

    def artists(self) -> Dict:
        endpoint = 'artist'

        return self._request(endpoint=endpoint)

    def artist(self, artist_id: int) -> Dict:
        endpoint = 'artist/{artist_id}'

        endpoint = endpoint.format(artist_id=artist_id)

        return self._request(endpoint=endpoint)

    def artist_delete(self, artist_id: int, delete_files: bool = False) -> Dict:
        endpoint = 'artist/{artist_id}'

        endpoint = endpoint.format(artist_id=artist_id)
        params = {
            'deleteFiles': delete_files,
        }

        return self._request(endpoint=endpoint, params=params, method='delete')

    def artist_lookup(self, term: str) -> Dict:
        endpoint = 'artist/lookup'

        params = {
            'term': term,
        }

        return self._request(endpoint=endpoint, params=params, method='delete')
