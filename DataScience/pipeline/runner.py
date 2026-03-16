from datetime import datetime

from pipeline.logger        import log, save_audit
from pipeline.ingestion     import ingest_all
from pipeline.cleaning      import clean_all
from pipeline.transformation import transform_all
from pipeline.validation    import validate_all
from pipeline.analytics     import compute_analytics
from pipeline.features      import build_feature_tables
from pipeline.export        import export_all


def run():
    started = datetime.now()
    log.info("Pipeline started at %s", started.strftime("%Y-%m-%d %H:%M:%S"))

    tables      = ingest_all()
    cleaned     = clean_all(tables)
    transformed = transform_all(cleaned)
    passed      = validate_all(transformed)
    insights    = compute_analytics(transformed)
    feat_tables = build_feature_tables(transformed)
    export_all(transformed, insights, feat_tables)

    elapsed = (datetime.now() - started).total_seconds()
    log.info("Pipeline %s in %.1fs", "PASSED" if passed else "COMPLETED WITH WARNINGS", elapsed)
