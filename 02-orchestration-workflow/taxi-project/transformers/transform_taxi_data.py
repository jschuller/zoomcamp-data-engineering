import pandas as pd

if 'transformer' not in globals():
    from mage_ai.data_preparation.decorators import transformer
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


@transformer
def transform(data, *args, **kwargs):

    print(f'Original row count = {data.shape[0]}')

    # Transformation 1: remove zero passenger or zero distance
    mask = (data['passenger_count'] != 0) & (data['trip_distance'] != 0)
    data = data[mask]
    print(f'Row count after removing passenger count equal to 0 or the trip distance equal to 0 = {data.shape[0]}')

    # Transformation 2: create lpep_pickup_date date
    data['lpep_pickup_date'] = pd.to_datetime(data['lpep_pickup_datetime'].dt.date)

    # Transformation 3: rename columns in camel case to snake case
    column_mapping = {
        'VendorID': 'vendor_id',
        'RatecodeID': 'ratecode_id',
        'PULocationID': 'pu_location_id',
        'DOLocationID': 'do_location_id'
        }
    data.rename(columns=column_mapping, inplace=True)
    print(f"The existing values of VendorID in the dataset are {data['vendor_id'].unique().tolist()}")


    return data


@test
def test_column_name(output, *args):
    assert output.columns.isin(['vendor_id']).any(), "vendor_id is one of the existing values in the column (currently)"

@test
def test_passenger_count(output, *args):
    assert output['passenger_count'].isin([0]).sum()==0, 'passenger_count is greater than 0'
    
@test
def test_trip_distance(output, *args):
    assert output['trip_distance'].isin([0]).sum()==0, 'trip_distance is greater than 0'