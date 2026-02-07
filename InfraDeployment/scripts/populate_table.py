from argparse import ArgumentParser
import json
from azure.data.tables import TableServiceClient, TableClient
from azure.identity import ClientSecretCredential
from azure.core.exceptions import ResourceExistsError
import collections.abc


def setup_parser() -> ArgumentParser:
    parser = ArgumentParser()
    parser.add_argument('filepath',
                        type=str,
                        help="filepath")

    parser.add_argument('table_name',
                        type=str,
                        help="Table Name")

    parser.add_argument('client_id',
                        type=str,
                        help="SPN client id")

    parser.add_argument('client_secret',
                        type=str,
                        help="SPN client secret")

    parser.add_argument('tenant_id',
                        type=str,
                        help="SPN tenant id")
    return parser


def load_file_content(filepath: str) -> dict:
    f = open(filepath, 'r')
    content = json.load(f)
    f.close()

    return content


def get_table_service_client(table_name: str,
                             tenant_id: str,
                             client_id: str,
                             client_secret: str) -> TableServiceClient:
    credential = ClientSecretCredential(tenant_id, client_id, client_secret)
    return TableServiceClient(
        endpoint=f"https://{table_name}.table.core.windows.net/",
        credential=credential)


def populate_tables(client: TableServiceClient, content: dict):
    for k, v in content.items():
        populate_table(client, k, v)


def populate_table(client: TableServiceClient,
                   table_name: str,
                   table_entity: dict):
    table_client = client.get_table_client(table_name=table_name)

    if isinstance(table_entity, collections.abc.Sequence):
        for entity in table_entity:
            create_entity(table_client, entity)
    else:
        create_entity(table_client, table_entity)


def create_entity(table_client: TableClient, entity: any):
    try:
        table_client.create_entity(entity)
    except ResourceExistsError:
        pass


if __name__ == "__main__":
    parser = setup_parser()

    args = parser.parse_args()

    content = load_file_content(args.filepath)
    client = get_table_service_client(args.table_name,
                                      args.tenant_id,
                                      args.client_id,
                                      args.client_secret)

    populate_tables(client=client, content=content)
